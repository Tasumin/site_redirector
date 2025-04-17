# 🌐 Serverless Redirector (Custom Domain, HTTP Only)

This project uses AWS CloudFront and Lambda@Edge to create a **serverless redirector** for short links, using your **custom domain** with **HTTP only** (no SSL).

Example:

```
http://go.example.com/servicedesk → https://subdomain.domain.com/servicedesk/portal
```

---

## ✅ Features

- Uses your own domain (e.g., `go.example.com`)
- Lambda@Edge for redirect logic
- No certificate or Route 53 needed
- Fully managed via Terraform

---

## 🚀 Deployment Steps

### 1. Set Your Domain

Create a `terraform.tfvars` file or pass the variable manually:

```hcl
custom_domain = "go.example.com"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Apply the Configuration

```bash
terraform apply
```

### 4. Update DNS

After deployment, you'll see a CloudFront URL like:

```
d1234abcd.cloudfront.net
```

Create a **CNAME record** in your DNS provider:

```
go.example.com  CNAME  d1234abcd.cloudfront.net
```

CloudFront will now respond to `http://go.example.com`.

---

## 🔁 Configure Custom Redirects

To add or change redirects:

1. Open the `redirect.js` file in this project.

2. Modify the `redirects` object inside the Lambda handler. For example:

```js
const redirects = {
    "servicedesk": "https://subdomain.domain.com/servicedesk/portal",
    "status": "https://status.domain.com",
    "help": "https://support.domain.com/helpdesk",
    "jira": "https://jira.domain.com",
    "wiki": "https://wiki.domain.com"
};
```

3. Save the file and re-deploy:

```bash
terraform apply
```

You can now access:
- `http://go.example.com/jira`
- `http://go.example.com/wiki`
- etc.

> ⚠️ Paths are exact matches only. Want wildcard or fallback support? Ask for an enhancement!

---

## 📦 Output

Terraform will output:

```
cloudfront_url = "d1234abcd.cloudfront.net"
```

Point your DNS to it and you're live.

---

## 🧼 Cleanup

```bash
terraform destroy
```

---

## 📄 License

MIT License
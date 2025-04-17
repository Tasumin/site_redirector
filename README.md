# 🌐 Serverless Redirector (HTTP Only)

This project uses AWS CloudFront and Lambda@Edge to create a simple **HTTP-based redirector** for short links like:

```
http://<cloudfront-domain>/servicedesk → https://subdomain.domain.com/servicedesk/portal
```

---

## ✅ Features

- HTTP-based redirector using CloudFront
- Lambda@Edge function for path matching
- Managed via Terraform
- No SSL/HTTPS or ACM required

---

## 🚀 How to Deploy

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Apply the Configuration

```bash
terraform apply
```

After deployment, Terraform will output the CloudFront domain.

---

## 🔁 Configure Redirects

Edit `redirect.js`:

```js
const redirects = {
    "servicedesk": "https://subdomain.domain.com/servicedesk/portal",
    "status": "https://status.domain.com",
    "help": "https://support.domain.com/helpdesk"
};
```

Then re-apply:

```bash
terraform apply
```

---

## 📦 Output

Terraform will output a CloudFront URL like:

```
http://xxxxxxxxxxxx.cloudfront.net/servicedesk
```

---

## 🧼 Cleanup

```bash
terraform destroy
```

---

## 📄 License

MIT License
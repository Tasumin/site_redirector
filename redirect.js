'use strict';

exports.handler = async (event) => {
    const request = event.Records[0].cf.request;
    const uri = request.uri.replace(/^\//, '').toLowerCase();

    const redirects = {
        "servicedesk": "https://subdomain.domain.com/servicedesk/portal",
        "status": "https://status.domain.com",
        "help": "https://support.domain.com/helpdesk",
        "jira": "https://jira.domain.com",
        "wiki": "https://wiki.domain.com"
    };

    if (redirects[uri]) {
        return {
            status: '301',
            statusDescription: 'Moved Permanently',
            headers: {
                location: [{
                    key: 'Location',
                    value: redirects[uri]
                }]
            }
        };
    }

    return request;
};
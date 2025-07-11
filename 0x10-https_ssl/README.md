# 0x10-https_ssl

This repository contains the implementation for HTTPS SSL tasks focusing on DNS configuration and HAproxy SSL termination.

## Task 0: World Wide Web (0-world_wide_web)

### Description
A Bash script that displays information about subdomains using `dig` and `awk`. The script provides DNS record information for specified subdomains.

### Usage
```bash
# Display information for all default subdomains (www, lb-01, web-01, web-02)
./0-world_wide_web yourdomain.com

# Display information for a specific subdomain
./0-world_wide_web yourdomain.com web-01
```

### Output Format
```
The subdomain [SUB_DOMAIN] is a [RECORD_TYPE] record and points to [DESTINATION]
```

### Requirements Met
- ✅ Accepts 2 arguments: domain (mandatory) and subdomain (optional)
- ✅ Uses `awk` for text processing
- ✅ Implements at least one Bash function
- ✅ Displays information in the specified format
- ✅ Handles default subdomains (www, lb-01, web-01, web-02) in order
- ✅ Ignores shellcheck case SC2086 as requested

### DNS Records Required
Before using the script, ensure these DNS A records are configured:
- `www.yourdomain.com` → lb-01 IP address
- `lb-01.yourdomain.com` → lb-01 IP address
- `web-01.yourdomain.com` → web-01 IP address
- `web-02.yourdomain.com` → web-02 IP address

## Task 1: HAproxy SSL Termination (1-haproxy_ssl_termination)

### Description
HAproxy configuration file for SSL termination that handles encrypted HTTPS traffic and forwards it to backend web servers.

### Features
- **SSL Termination**: HAproxy handles SSL/TLS encryption and decryption
- **Port 443**: Listens on standard HTTPS port
- **HTTP to HTTPS Redirect**: Automatically redirects HTTP traffic to HTTPS
- **Load Balancing**: Distributes traffic between web-01 and web-02 servers
- **Security Headers**: Implements HSTS, X-Frame-Options, and X-Content-Type-Options
- **Certificate Management**: Supports Let's Encrypt certificate renewal
- **Health Checks**: Monitors backend server health

### Configuration Highlights
```
Frontend:
- HTTP (port 80) → HTTPS redirect
- HTTPS (port 443) → SSL termination with certificate

Backend:
- Round-robin load balancing
- Health checks on backend servers
- Server identification headers
```

### Requirements Met
- ✅ HAproxy listens on port TCP 443
- ✅ HAproxy accepts SSL traffic
- ✅ HAproxy serves encrypted traffic returning the `/` of web servers
- ✅ Root domain query returns pages containing "ALX"
- ✅ Configuration file provided as `1-haproxy_ssl_termination`
- ✅ Compatible with HAproxy 1.5 or higher

### Certificate Setup
The configuration expects SSL certificates to be located at:
```
/etc/haproxy/certs/www.yourdomain.com.pem
```

This file should contain both the certificate and private key concatenated together.

### Backend Server Configuration
Backend servers should serve content containing "ALX" at the document root. Example:
```bash
echo "ALX for the win!" > /var/www/html/index.html
```

## Files

- `0-world_wide_web` - Bash script for subdomain information
- `1-haproxy_ssl_termination` - HAproxy SSL configuration
- `1-haproxy_ssl_termination.example` - Example configuration with sample IPs
- `SETUP_GUIDE.md` - Comprehensive setup instructions
- `README.md` - This documentation

## Security Features

The HAproxy configuration includes several security enhancements:
- Strong SSL cipher suites
- Disabled SSLv3 and TLS tickets
- HSTS (HTTP Strict Transport Security)
- X-Frame-Options header
- X-Content-Type-Options header
- Automatic HTTP to HTTPS redirection

## Testing

### DNS Testing
```bash
# Test subdomain resolution
dig www.yourdomain.com
./0-world_wide_web yourdomain.com
```

### SSL Testing
```bash
# Test HTTP to HTTPS redirect
curl -I http://www.yourdomain.com

# Test HTTPS connection
curl -I https://www.yourdomain.com

# Test content
curl https://www.yourdomain.com
```

## Task 2: No Loophole in Website Traffic (100-redirect_http_to_https)

### Description
Advanced HAproxy configuration that enforces HTTPS traffic by automatically redirecting all HTTP requests to HTTPS. This ensures no unencrypted traffic is possible.

### Features
- **Automatic HTTP to HTTPS Redirect**: All HTTP traffic is redirected to HTTPS with 301 status code
- **Transparent to User**: Redirection happens seamlessly without user intervention
- **Enhanced Security**: Prevents any unencrypted traffic from reaching the backend
- **SEO Friendly**: Uses 301 permanent redirect status code
- **Additional Security Headers**: Includes XSS protection and other security headers

### Requirements Met
- ✅ Transparent to the user
- ✅ HAproxy returns a 301 status code
- ✅ HAproxy redirects HTTP traffic to HTTPS
- ✅ Configuration file provided as `100-redirect_http_to_https`
- ✅ No loophole for unencrypted traffic

### HTTP to HTTPS Redirect Behavior
```bash
# Example curl command showing the redirect
curl -sIL http://www.holberton.online

# Expected output:
# HTTP/1.1 301 Moved Permanently
# Content-length: 0
# Location: https://www.holberton.online/
# Connection: close
#
# HTTP/1.1 200 OK
# Server: nginx/1.4.6 (Ubuntu)
# ...
```

### Key Configuration Features
- **Port 80 Frontend**: Exclusively handles HTTP to HTTPS redirection
- **Port 443 Frontend**: Handles all HTTPS traffic with SSL termination
- **301 Redirect**: Permanent redirect ensures SEO benefits
- **Security Headers**: HSTS, X-Frame-Options, X-Content-Type-Options, X-XSS-Protection
- **Let's Encrypt Support**: ACL for certificate renewal challenges

## Files

- `0-world_wide_web` - Bash script for subdomain information
- `1-haproxy_ssl_termination` - HAproxy SSL configuration
- `1-haproxy_ssl_termination.example` - Example configuration with sample IPs
- `100-redirect_http_to_https` - Advanced HAproxy config with HTTP to HTTPS redirection
- `100-redirect_http_to_https.template` - Template version with placeholder IPs
- `SETUP_GUIDE.md` - Comprehensive setup instructions
- `README.md` - This documentation

## Repository Structure
```
alx-system_engineering-devops/
└── 0x10-https_ssl/
    ├── 0-world_wide_web
    ├── 1-haproxy_ssl_termination
    ├── 1-haproxy_ssl_termination.example
    ├── 100-redirect_http_to_https
    ├── 100-redirect_http_to_https.template
    ├── SETUP_GUIDE.md
    ├── README.md
    └── TASK_COMPLETION.md
```

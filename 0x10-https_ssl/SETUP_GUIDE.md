# HTTPS SSL Setup Guide

## Task 0: World Wide Web - DNS Configuration

### Required DNS Records

You need to configure your domain's DNS settings to include the following A records:

```
www.yourdomain.com      -> lb-01-ip-address
lb-01.yourdomain.com    -> lb-01-ip-address
web-01.yourdomain.com   -> web-01-ip-address
web-02.yourdomain.com   -> web-02-ip-address
```

### DNS Configuration Steps

1. **Access your domain registrar's DNS management panel**
2. **Add the following A records:**
   - Name: `www`, Value: `[YOUR-LB-01-IP]`
   - Name: `lb-01`, Value: `[YOUR-LB-01-IP]`
   - Name: `web-01`, Value: `[YOUR-WEB-01-IP]`
   - Name: `web-02`, Value: `[YOUR-WEB-02-IP]`

### Script Usage

The `0-world_wide_web` script can be used as follows:

```bash
# Display all default subdomains
./0-world_wide_web yourdomain.com

# Display specific subdomain
./0-world_wide_web yourdomain.com web-01
```

## Task 1: HAproxy SSL Termination Setup

### Prerequisites

1. **Install HAproxy 1.5 or higher**
   ```bash
   sudo apt-get update
   sudo apt-get install haproxy
   ```

2. **Install Certbot**
   ```bash
   sudo apt-get install certbot
   ```

### SSL Certificate Generation

1. **Stop HAproxy temporarily**
   ```bash
   sudo systemctl stop haproxy
   ```

2. **Generate SSL certificate using Certbot**
   ```bash
   sudo certbot certonly --standalone -d www.yourdomain.com
   ```

3. **Create certificate directory**
   ```bash
   sudo mkdir -p /etc/haproxy/certs
   ```

4. **Combine certificate and private key**
   ```bash
   sudo cat /etc/letsencrypt/live/www.yourdomain.com/fullchain.pem \
            /etc/letsencrypt/live/www.yourdomain.com/privkey.pem \
            > /etc/haproxy/certs/www.yourdomain.com.pem
   ```

5. **Set proper permissions**
   ```bash
   sudo chmod 600 /etc/haproxy/certs/www.yourdomain.com.pem
   sudo chown haproxy:haproxy /etc/haproxy/certs/www.yourdomain.com.pem
   ```

### HAproxy Configuration

1. **Backup existing configuration**
   ```bash
   sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.backup
   ```

2. **Replace with new configuration**
   ```bash
   sudo cp 1-haproxy_ssl_termination /etc/haproxy/haproxy.cfg
   ```

3. **Update IP addresses in the configuration**
   - Replace `[WEB-01-IP]` with your actual web-01 server IP
   - Replace `[WEB-02-IP]` with your actual web-02 server IP
   - Replace `yourdomain.com` with your actual domain

4. **Test configuration**
   ```bash
   sudo haproxy -f /etc/haproxy/haproxy.cfg -c
   ```

5. **Start HAproxy**
   ```bash
   sudo systemctl start haproxy
   sudo systemctl enable haproxy
   ```

### Web Server Configuration

Ensure your web servers (web-01 and web-02) have content that includes "ALX":

```bash
# On each web server
echo "ALX for the win!" | sudo tee /var/www/html/index.html
```

### Certificate Renewal

Set up automatic renewal:

```bash
# Add to crontab
sudo crontab -e

# Add this line for monthly renewal
0 0 1 * * /usr/bin/certbot renew --quiet && cat /etc/letsencrypt/live/www.yourdomain.com/fullchain.pem /etc/letsencrypt/live/www.yourdomain.com/privkey.pem > /etc/haproxy/certs/www.yourdomain.com.pem && systemctl reload haproxy
```

### Testing

1. **Test HTTP to HTTPS redirect**
   ```bash
   curl -I http://www.yourdomain.com
   ```

2. **Test HTTPS connection**
   ```bash
   curl -I https://www.yourdomain.com
   ```

3. **Test content**
   ```bash
   curl https://www.yourdomain.com
   ```

The response should contain "ALX" in the content.

### Troubleshooting

1. **Check HAproxy logs**
   ```bash
   sudo tail -f /var/log/haproxy.log
   ```

2. **Check certificate expiry**
   ```bash
   sudo certbot certificates
   ```

3. **Check HAproxy status**
   ```bash
   sudo systemctl status haproxy
   ```

4. **Verify DNS propagation**
   ```bash
   dig www.yourdomain.com
   ```

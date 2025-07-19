# 0x18. Webstack Monitoring

This directory contains the Datadog monitoring setup tasks.

## Task 0: Sign up for Datadog and install datadog-agent

### Manual Steps Required:

1. **Sign up for Datadog**:
   - Visit: https://app.datadoghq.com
   - Create account using US1 region
   - Note your API key from Organization Settings → API Keys

2. **Create Application Key**:
   - Go to Organization Settings → Application Keys
   - Create new application key
   - Copy both API key and Application key to your Intranet profile

3. **Install Datadog Agent on web-01**:
   ```bash
   # SSH into your web-01 server
   # Replace YOUR_API_KEY with your actual API key
   DD_API_KEY=YOUR_API_KEY DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
   ```

4. **Update hostname (if needed)**:
   ```bash
   sudo sed -i 's/# hostname:.*/hostname: XX-web-01/' /etc/datadog-agent/datadog.yaml
   sudo systemctl restart datadog-agent
   ```

5. **Verify installation**:
   ```bash
   sudo datadog-agent status
   ```

## Task 1: Monitor some metrics

### Create monitors in Datadog dashboard:

1. **Monitor for disk read requests**:
   - Go to Monitors → New Monitor
   - Select "Metric" monitor type
   - Metric: `system.io.r_s` (read requests per second)
   - Set appropriate thresholds

2. **Monitor for disk write requests**:
   - Go to Monitors → New Monitor  
   - Select "Metric" monitor type
   - Metric: `system.io.w_s` (write requests per second)
   - Set appropriate thresholds

## Task 2: Create a dashboard

### Steps:
1. **Create new dashboard** in Datadog
2. **Add 4+ widgets** (suggestions):
   - CPU usage graph
   - Memory usage graph  
   - Disk I/O metrics
   - Network traffic
   - Load average
   - Process list

3. **Get dashboard ID**:
   - Use Datadog API or check URL
   - Update the `2-setup_datadog` file with the dashboard ID

### API command to get dashboard ID:
```bash
curl -X GET "https://api.datadoghq.com/api/v1/dashboard" \
     -H "Content-Type: application/json" \
     -H "DD-API-KEY: YOUR_API_KEY" \
     -H "DD-APPLICATION-KEY: YOUR_APP_KEY"
```

## Files:
- `2-setup_datadog`: Contains the dashboard ID (update after creating dashboard)

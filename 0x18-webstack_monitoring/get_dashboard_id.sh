#!/bin/bash
# Script to get Datadog dashboard ID
# Usage: ./get_dashboard_id.sh YOUR_API_KEY YOUR_APP_KEY

if [ $# -ne 2 ]; then
    echo "Usage: $0 <DD_API_KEY> <DD_APP_KEY>"
    echo "Example: $0 abc123def456 xyz789abc123"
    exit 1
fi

DD_API_KEY="$1"
DD_APP_KEY="$2"

echo "Fetching dashboard list from Datadog API..."

curl -X GET "https://api.datadoghq.com/api/v1/dashboard" \
     -H "Content-Type: application/json" \
     -H "DD-API-KEY: ${DD_API_KEY}" \
     -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
     | python -m json.tool

echo ""
echo "Look for your dashboard in the output above."
echo "Find the 'id' field of your dashboard and update the 2-setup_datadog file."

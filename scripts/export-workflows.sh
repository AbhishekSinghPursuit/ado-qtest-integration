#!/bin/bash 

# n8n API Key & curl: Only for self-hosted or cloud enterprise users with elevated access. Not available to standard n8n Cloud users.

# For n8n Cloud:
# Use the web UI’s download/import features for workflow migration and manual version control.
 
# Configuration 
N8N_URL="http://localhost:5678" 
N8N_API_KEY="your-api-key"  # Set in n8n settings 
OUTPUT_DIR="./workflows" 
 
# Create output directory if not exists 
mkdir -p "$OUTPUT_DIR" 
 
# Export all workflows 
echo "Exporting workflows from n8n..." 
 
# List all workflows 
workflows=$(curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" \ 
  "$N8N_URL/api/v1/workflows" | jq -r '.data[].id') 
 
for workflow_id in $workflows; do 
  # Get workflow details 
  workflow_data=$(curl -s -H "X-N8N-API-KEY: $N8N_API_KEY" \ 
    "$N8N_URL/api/v1/workflows/$workflow_id") 
   
  # Get workflow name 
  workflow_name=$(echo "$workflow_data" | jq -r '.name' | \ 
    tr ' ' '-' | tr '[:upper:]' '[:lower:]') 
   
  # Save to file 
  echo "$workflow_data" | jq '.' > "$OUTPUT_DIR/${workflow_name}.json" 
   
  echo "Exported: $workflow_name" 
done 
 
echo "Export complete!"

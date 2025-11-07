#!/bin/bash 
 
# n8n API Key & curl: Only for self-hosted or cloud enterprise users with elevated access. Not available to standard n8n Cloud users.

# For n8n Cloud:
# Use the web UI’s download/import features for workflow migration and manual version control.


# Configuration 
N8N_URL="http://localhost:5678" 
N8N_API_KEY="your-api-key" 
WORKFLOWS_DIR="./workflows" 
 
# Check if workflow file provided 
if [ -z "$1" ]; then 
  echo "Usage: ./import-workflows.sh <workflow-file.json>" 
  exit 1 
fi 
 
WORKFLOW_FILE="$WORKFLOWS_DIR/$1" 
 
if [ ! -f "$WORKFLOW_FILE" ]; then 
  echo "Error: Workflow file not found: $WORKFLOW_FILE" 
  exit 1 
fi 
 
echo "Importing workflow: $WORKFLOW_FILE" 
 
# Import workflow 
response=$(curl -s -X POST \ 
  -H "X-N8N-API-KEY: $N8N_API_KEY" \ 
  -H "Content-Type: application/json" \ 
  -d @"$WORKFLOW_FILE" \ 
  "$N8N_URL/api/v1/workflows") 
 
# Check if successful 
if echo "$response" | jq -e '.id' > /dev/null; then 
  workflow_id=$(echo "$response" | jq -r '.id') 
  echo "✅ Successfully imported workflow with ID: $workflow_id" 
else 
  echo "❌ Failed to import workflow" 
  echo "$response" | jq '.' 
  exit 1 
fi

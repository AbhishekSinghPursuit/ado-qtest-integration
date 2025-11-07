## Troubleshooting Guide (For Backup) 

### If (Create) Doesn't Work 

#### Possible causes: 
- n8n workflow not activated 
- Webhook URL changed 
- Azure DevOps service hook not triggered 

#### Quick Fix: 
- Check n8n toggle is ON (green) 
- Test the service hook manually in Azure DevOps 
- Check n8n executions for errors 

### If (Update) Doesn't Work 

#### Possible causes: 
- Update service hook not configured 
- Field filter too restrictive 
- Requirement not found by Azure DevOps ID 

#### Quick Fix: 
- Ensure you're changing a field value 
- Check n8n logs for "not found" errors 
- Verify Azure DevOps ID was stored in qTest 

### If (Delete) Doesn't Work 

#### Possible causes: 
- Delete service hook not enabled 
- Requirement doesn't exist 

#### Quick Fix: 
- Confirm task was deleted (not just moved) 
- Check Azure DevOps service hook history for delivery attempts 

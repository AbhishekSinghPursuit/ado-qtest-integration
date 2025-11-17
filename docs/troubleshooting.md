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

### If you get error respone like - "Project is not found"

#### Possible causes: 
- Project configuration in `Load Configuration - Js` node is missing or incorrect
- Bearer Auth Token for the particular qTest project with the respective qTest account is not set correclty in `HTTP Request` nodes

#### Quick Fix: 
- Make sure project configurations like - qTest project id, qTest API URL, requirements parent id are correct and match with you project 
- If you are using a qTest project of different account then you will need to find out its separate Bearer access token for the qTest project and then create a new credential into n8n and then select that credential into `HTTP Request` nodes. If you are using same different qTest project withing same qTest account then make sure user has permissions to manager all the permissions using API. 

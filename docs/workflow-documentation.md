# ADO-qTest Integration Workflow Documentation 
 
## Overview 
This workflow synchronizes Tasks from Azure DevOps Boards to Requirements in qTest. 

## Complete Implementation Guide
[ADO-qTest Integration Guide](https://pursuitsoftwarebiz-my.sharepoint.com/:w:/g/personal/abhishek_s_pursuitsoftware_com/ETiML2N9efVDr-Ykz3U49nsBbCte6L1nF4QmEL86MgrsnQ?e=S0J1hm)

## Workflow Summary
This workflow creates an integration between Azure DevOps work items and qTest requirements:
1. Receives webhook events from Azure DevOps
2. Routes events based on type (create/update/delete)
3. Performs corresponding operations in qTest
4. Maintains data synchronization between both systems
5. Logs each succeeded or failed execution of the workflow in a google sheet
 
## Workflow Nodes 
 
### 1. Webhook Node 
- **Type:** Webhook
- **Method:** POST
- **Path:** `azure-dev-ops-task`
- **Purpose:** Receives events from Azure DevOps Service Hooks 
- **Triggers:** workitem.created, workitem.updated, workitem.deleted 
- **URL:** https://office-workflows.app.n8n.cloud/webhook/azure-dev-ops-task 
- **Response Mode**: lastNode
- **Output**: Raw webhook body forwarded to Load Configurations - JS
 
### 2. Load Configurations - JS Node 
- **Purpose:** Extract project name and minimal webhook metadata 
- **Type:** Code (JavaScript) 
- **Input:** Webhook body from Event Webhook 
- **Output:** { webhookData, azureProjectName, eventType } 
  
### 3. Build Dynamic Payload - JS Node  
- **Purpose:** Map ADO fields to qTest payload, select project config and simulate errors for tests  
- **Type:** Code (JavaScript)  
- **Input:** webhookData + azureProjectName from Load Configurations - JS  
- **Authentication:** none  
- **Output:** { payload, qtest_url, qtest_project_id, workitem_id, projectName, projectConfig, errorSimulation, retryCount }

### 4. is payload created successfully? Node  
- **Purpose:** Validate payload creation and route success vs payload-failure logging  
- **Type:** If  
- **Input:** Output from Build Dynamic Payload - JS (checks json.error)  
- **Authentication:** none  
- **Output:** Success → Event Switch; Failure → Payload creation failure Log

### 5. Event Switch Node 
- **Purpose:** Route workflow by Azure DevOps event type (create/update/delete)
- **Type**: Switch
- **Input**: item.json.eventType from Build Dynamic Payload - JS
- **Routes:** 
  - Create (workitem.created) 
  - Update (workitem.updated) 
  - Delete (workitem.deleted) 
- **Output**: Branches: `Created`, `Updated`, `Deleted`

### 6. Create-HTTP Request Node  
- **Purpose:** Creates new requirements in qTest  
- **Type:** HTTP Request  
- **Method:** POST  
- **URL:** ={{ $json.qtest_url }}/api/v3/projects/{{ $json.qtest_project_id }}/requirements  
- **Input:** qTest payload (from Build Dynamic Payload - JS)  
- **Authentication:** Bearer Token (httpBearerAuth credential: Bearer Auth account 2)  
- **Output:** Created requirement response (JSON)  
- **Retry:** retryOnFail true, waitBetweenTries 2000ms  
- **OnError:** continueErrorOutput

### 7. Check For Create Response Status Node  
- **Purpose:** Inspect Create response and normalize success/error object for logging  
- **Type:** Code (JavaScript)  
- **Input:** Response from Create-HTTP Request  
- **Authentication:** none  
- **Output:** { success, operation, qtest_requirement_id, error_message, status_code, original_data }

### 8. If success or failed? Create Node  
- **Purpose:** Route create result to success- or failure-logging  
- **Type:** If  
- **Input:** output.success from Check For Create Response Status  
- **Authentication:** none  
- **Output:** Success → Success Logging Node - Create; Failure → Error Logging Node - Create

### 9. Success Logging Node - Create  
- **Purpose:** Format success log row for Google Sheet after create  
- **Type:** Code (JavaScript)  
- **Input:** success object from Check For Create Response Status  
- **Authentication:** none  
- **Output:** Structured row JSON for Add Success Logs to Worksheet - Create

### 10. Add Success Logs to Worksheet - Create  
- **Purpose:** Append successful create execution to Google Sheet (Successes)  
- **Type:** Google Sheets (append)  
- **Operation:** append  
- **Document:** ADO-qTest Logs  
- **Sheet:** gid=0 (Sucesses)  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)  
- **Output:** Google Sheets append response

### 11. Error Logging Node - Create  
- **Purpose:** Format error log row for Google Sheet after create failure  
- **Type:** Code (JavaScript)  
- **Input:** error object from Check For Create Response Status  
- **Authentication:** none  
- **Output:** Structured row JSON for Add Failure Logs to Worksheet- Create

### 12. Add Failure Logs to Worksheet- Create  
- **Purpose:** Append create failure to Google Sheet (Errors)  
- **Type:** Google Sheets (append)  
- **Sheet:** 829971239 (Errors)  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)

### 13. Search Req-HTTP Request - Update Node  
- **Purpose:** Search qTest for requirement by Azure_DevOps_ID (update flow)  
- **Type:** HTTP Request  
- **Method:** POST  
- **URL:** ={{ $json.qtest_url }}/api/v3/projects/{{ $json.qtest_project_id }}/search  
- **Body:** Query for object_type=requirements and 'Azure_DevOps_ID' = {{ $json.workitem_id }}  
- **Authentication:** Bearer Token (Bearer Auth account 2)  
- **Output:** Search response (items[] or error)  
- **Retry:** retryOnFail true  
- **OnError:** continueErrorOutput

### 14. Extract Req Id - JS - Update Node  
- **Purpose:** Parse search response and extract requirement id (update flow)  
- **Type:** Code (JavaScript)  
- **Input:** Search Req-HTTP Request - Update response  
- **Authentication:** none  
- **Output:** { requirementId, found(boolean), dataFound, azureDevOpsData, original_data, projectConfig }

### 15. Is search succeeded? Update Node  
- **Purpose:** Decide whether search returned usable result or error; route to update or search-error logging  
- **Type:** If  
- **Input:** Extract Req Id - JS - Update outputs  
- **Authentication:** none  
- **Output:** True → Req Found? Update; False → Error Logging Node - Search-Update

### 16. Req Found? Update Node  
- **Purpose:** Confirm requirement found before calling Update HTTP node  
- **Type:** If  
- **Input:** found boolean from Extract Req Id - JS - Update  
- **Authentication:** none  
- **Output:** True → Update-HTTP Request

### 17. Update-HTTP Request Node  
- **Purpose:** Update an existing requirement in qTest  
- **Type:** HTTP Request  
- **Method:** PUT  
- **URL:** **{{ \$('Event Switch').item.json.qtest_url }}**/api/v3/projects/**{{ $('Event Switch').item.json.qtest_project_id }}**/requirements/**{{ $json.requirementId }}**  
- **Input:** payload properties from Event Switch payload  
- **Authentication:** Bearer Token (Bearer Auth account 2)  
- **Output:** Update response JSON  
- **Retry:** retryOnFail true  
- **OnError:** continueErrorOutput

### 18. Check For Update Response Status Node  
- **Purpose:** Inspect Update response and normalize success/error object for logging  
- **Type:** Code (JavaScript)  
- **Input:** Response from Update-HTTP Request  
- **Authentication:** none  
- **Output:** { success, operation, qtest_requirement_id, error_message, status_code, original_data }

### 19. If success or failed? Update Node  
- **Purpose:** Route update result to success- or failure-logging  
- **Type:** If  
- **Input:** output.success from Check For Update Response Status  
- **Authentication:** none  
- **Output:** **Success** → Success Logging Node - Update; **Failure** → Error Logging Node - Update

### 20. Success Logging Node - Update  
- **Purpose:** Format success log row for Google Sheet after update  
- **Type:** Code (JavaScript)  
- **Input:** success object from Check For Update Response Status  
- **Authentication:** none  
- **Output:** Structured row JSON for Add Success Logs to Worksheet - Update

### 21. Add Success Logs to Worksheet - Update  
- **Purpose:** Append successful update execution to Google Sheet (Successes)  
- **Type:** Google Sheets (append) - gid=0 (Successes)  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)

### 22. Error Logging Node - Update  
- **Purpose:** Format error log row for Google Sheet after update failure  
- **Type:** Code (JavaScript)  
- **Input:** error object from Check For Update Response Status  
- **Authentication:** none  
- **Output:** Structured row JSON for Add Failure Logs to Worksheet - Update

### 23. Add Failure Logs to Worksheet - Update  
- **Purpose:** Append update failure to Google Sheet (Errors)  
- **Type:** Google Sheets (append) — sheet 829971239 (Errors)  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)

### 24. Search Req-HTTP Request - Delete Node  
- **Purpose:** Search qTest for requirement by Azure_DevOps_ID (delete flow)  
- **Type:** HTTP Request  
- **Method:** POST  
- **URL:** **={{ $json.qtest_url }}**/api/v3/projects/**{{ $json.qtest_project_id }}**/search  
- **Body:** Query for object_type=requirements and 'Azure_DevOps_ID' = **{{ $json.workitem_id }}**  
- **Authentication:** Bearer Token (Bearer Auth account 2)  
- **Output:** Search response (items[] or error)  
- **Retry:** retryOnFail true  
- **OnError:** continueErrorOutput

### 25. Extract Req Id - JS - Delete Node  
- **Purpose:** Parse delete-search response and extract requirement id (delete flow)  
- **Type:** Code (JavaScript)  
- **Input:** Search Req-HTTP Request - Delete response  
- **Authentication:** none  
- **Output:** { requirementId, found(boolean), dataFound, error_message, status_code, original_data, azureDevOpsData }

### 26. Is search succeeded? Delete Node  
- **Purpose:** Decide whether delete search returned usable result or error; route to delete or search-error logging  
- **Type:** If  
- **Input:** Extract Req Id - JS - Delete outputs  
- **Authentication:** none  
- **Output:** **True** → Req Found? Delete; **False** → Error Logging Node - Search-Delete

### 26. Req Found? Delete Node  
- **Purpose:** Confirm requirement found before calling Delete HTTP node  
- **Type:** If  
- **Input:** found boolean from Extract Req Id - JS - Delete  
- **Authentication:** none  
- **Output:** True → Delete-HTTP Request

### 27. Delete-HTTP Request Node  
- **Purpose:** Delete requirement in qTest  
- **Type:** HTTP Request  
- **Method:** DELETE  
- **URL:** **={{ \$('Event Switch').item.json.qtest_url }}**/api/v3/projects/**{{ $('Event Switch').item.json.qtest_project_id }}**/requirements/**{{ $json.requirementId }}**  
- **Input:** requirementId from Extract Req Id - JS - Delete  
- **Authentication:** Bearer Token (Bearer Auth account 2)  
- **Output:** Text/response indicating deletion or error  
- **Retry:** retryOnFail true  
- **OnError:** continueErrorOutput

### 28. Check For Delete Response Status Node  
- **Purpose:** Inspect Delete response and normalize success/error object for logging  
- **Type:** Code (JavaScript)  
- **Input:** Response from Delete-HTTP Request and context from Req Found? Delete  
- **Authentication:** none  
- **Output:** { success, operation, qtest_requirement_id, error_message, status_code, original_data }

### 29. If success or failed? Delete Node  
- **Purpose:** Route delete result to success- or failure-logging  
- **Type:** If  
- **Input:** output.success from Check For Delete Response Status  
- **Authentication:** none  
- **Output:** Success → Success Logging Node - Delete; Failure → Error Logging Node - Delete

### 30. Success Logging Node - Delete  
- **Purpose:** Format success log row for Google Sheet after delete  
- **Type:** Code (JavaScript)  
- **Input:** success object from Check For Delete Response Status  
- **Authentication:** none  
- **Output:** Structured row JSON for Add Success Logs to Worksheet - Delete

### 31. Add Success Logs to Worksheet - Delete  
- **Purpose:** Append successful delete execution to Google Sheet (Successes)  
- **Type:** Google Sheets (append) - gid=0 (Sucesses)  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)

### 32. Error Logging Node - Delete  
- **Purpose:** Format error log row for Google Sheet after delete failure  
- **Type:** Code (JavaScript)  
- **Input:** error object from Check For Delete Response Status  
- **Authentication:** none  
- **Output:** Structured row JSON for Add Failure Logs to Worksheet - Delete

### 33. Add Failure Logs to Worksheet - Delete  
- **Purpose:** Append delete failure to Google Sheet (Errors)  
- **Type:** Google Sheets (append) - sheet 829971239 (Errors)  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)

### 34. Payload creation failure Log  
- **Purpose:** Append payload-creation failures to Google Sheet (Errors) when Build Dynamic Payload fails  
- **Type:** Google Sheets (append) - sheet 829971239 (Errors)  
- **Input:** logFields from Build Dynamic Payload - JS error output  
- **Authentication:** googleSheetsOAuth2Api (qTest Log Sheet)

### 35. Sticky Note nodes (multiple)  
- **Purpose:** Visual documentation and operational guidance inside the canvas (overview, webhook, build payload, config, switch, create/update/delete flows, retry policy, error handling, logging, testing, credentials, naming conventions)  
- **Type:** Sticky Note  
- **Input:** none (visual only)  
- **Output:** none

### 36. Operational notes (from sticky nodes)  
- **Purpose:** Reference for credential names, retry policy (retryOnFail + waitBetweenTries 2000ms), recommended testing flags (simulateManualError / simulateInvalidUrl)  
- **Type:** Documentation (sticky + node configs)  
- **Input:** none  
- **Output:** none

## Configuration 
 
### Required Credentials 
1. **Azure DevOps PAT** - Read access to Work Items 
2. **qTest API Token** - Full access to Requirements 
3. **MySQL Connection** - For logging 
 
### Project Configuration 
See `workflows/project-config.json` for structure. 
 
Each project needs: 
- qTest project ID 
- Field ID mappings 
- Parent requirement ID 
- Default status 
 
## Error Handling 
Errors are: 
1. Logged to `ADO-qTest Logs` google sheet 
2. Sent to DevOps team via email 
3. Retried (for transient failures) 
4. Tracked until resolved 
 
## Monitoring 
- Check execution logs in n8n UI 
- Query database for success/error rates 
- Monitor email alerts 
 
## Troubleshooting 
See [docs/troubleshooting](/docs/troubleshooting.md)

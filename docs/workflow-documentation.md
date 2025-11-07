# ADO to qTest Integration Workflow Documentation 
 
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
 
## Workflow Nodes 
 
### 1. Webhook Node 
- **Type**: Webhook
- **Method**: POST
- **Path**: `azure-dev-ops-task`
- **Purpose:** Receives events from Azure DevOps Service Hooks 
- **Triggers:** workitem.created, workitem.updated, workitem.deleted 
- **URL:** https://office-workflows.app.n8n.cloud/webhook/azure-dev-ops-task 
- **Response Mode**: lastNode
- **Output**: Webhook payload with work item events
 
### 2. Configuration Lookup Node 
- **Purpose:** Loads project-specific configurations 
- **Type:** Code Node 
- **Input:** Azure DevOps project name 
- **Output:** qTest project ID, field mappings, API credentials 
 
### 3. Switch Node - Event Router 
- **Purpose:** Routes workflow based on event type from Azure DevOps
- **Type**: Switch/Conditional
- **Input**: Webhook payload
- **Output**: Routes to appropriate HTTP requests
- **Purpose:** Routes to appropriate branch based on event type 
- **Routes:** 
  - Create (workitem.created) 
  - Update (workitem.updated) 
  - Delete (workitem.deleted) 
 
### 4. Create-HTTP Request Node
- **Purpose:** Creates new requirements in qTest
- **Type**: HTTP Request
- **Method**: POST
- **URL**: `https://office000test.qtestnet.com/api/v3/projects/23379/requirements`
- **Authentication**: Bearer Token
- **Input**: Work item data from Azure DevOps
- **Parameters**:
  - parentId: 5190560
- **Body**: JSON with work item fields mapping

### 5. Search Req-HTTP Request Nodes
- **Purpose:** Searches for existing requirements in qTest
- **Type**: HTTP Request
- **Method**: POST
- **URL**: `https://office000test.qtestnet.com/api/v3/projects/23379/search`
- **Authentication**: Bearer Token
- **Input**: Azure DevOps work item ID
- **Body**: JSON search query
- **Used For**: Update and Delete operations

### 6. Extract Req ID - JS Nodes
- **Purpose:** Processes search results to extract requirement IDs
- **Type**: Code (JavaScript)
- **Input**: qTest search results
- **Output**: 
  - requirementId
  - found status
  - azureDevOpsData

### 7. Requirement Found? Nodes
- **Purpose:** Conditional routing based on requirement existence
- **Type**: If Condition
- **Input**: Processed search results
- **Condition**: `found === true`
- **Output**: Routes to update/delete operations

### 8. Update-HTTP Request Node
- **Purpose:** Updates existing requirements in qTest
- **Type**: HTTP Request
- **Method**: PUT
- **URL**: Dynamic with requirement ID
- **Authentication**: Bearer Token
- **Parameters**:
  - parentId: 5190560
- **Body**: JSON with updated work item fields

### 9. Delete-HTTP Request Node
- **Purpose:** Removes requirements from qTest
- **Type**: HTTP Request
- **Method**: DELETE
- **URL**: Dynamic with requirement ID
- **Authentication**: Bearer Token
- **Parameters**:
  - parentId: 5190560
 
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
1. Logged to `error_logs` table 
2. Sent to DevOps team via email 
3. Retried (for transient failures) 
4. Tracked until resolved 
 
## Monitoring 
- Check execution logs in n8n UI 
- Query database for success/error rates 
- Monitor email alerts 
 
## Troubleshooting 
See `docs/troubleshooting.md`
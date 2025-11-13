# Workflow Version History 

## Version 1.0.0 (2025-11-01) 
**Author:** Abhishek Singh
 
### Added 
- Initial implementation 
- Create, Update, Delete operations 
- Basic qTest integration 

## Version 2.0.0 (2025-11-10) 
**Author:** Abhishek Singh
 
### Added 
- Workflow implementation for Multiple qTest projects statrted
- Load Config data node added after webhook node

## Version 2.0.1 (2025-11-10) 
**Author:** Abhishek Singh
 
### Added 
- A `Code Node` added to after `Webhook Node` to extract the project details of ADO event
- A `Switch Node` add after this Code node to switch with respect to specific project and creates branches
- For now two branches are added for two projects `nodeautomation` and `nodeautomation2` projects
- Both branhces start with a `Code Node` that creates the dynamic payload of the event data coming from the ADO Board, this node sends the payload and other details to the next `Switch Node`
- This another `Switch Node` checks the event type `(Create/Update/Delete)` and then allows the flow in the respective branch
- The same implementation for another branch of qTest project

### Changes
- Earlier configuration data like `field IDs` of qTest requirement, `parent ID` of the requirement were hard coded, now they are accessible dynamically from the payload data

## Version 2.0.2 (2025-11-10) 
**Author:** Abhishek Singh

### Removed
- As in the last version `2.0.1` I had added a switch node to route on specific project branch, workflow became very crowded as there would be separate branches for each project that we have
- `Switch Node` for routing the specific project branch has been removed for optimising the overhead of separate branches
- As result, removed the second branch for the the project, now only one branch is there for event routing with respect to different projects

### Changes
- The `Code Node` for loading the project details is changed to Load the configurations of the different projects
- Also updated the dynamic payload creating `Code Node` so that it can create payload according to the specific project configuration
 
## Version 3.0.0 (2025-11-11) 
**Author:** Abhishek Singh

### Added
- In this version I have impelemented the Custom Error  (Manual error injection or Invalid URL simulations) handling in the n8n workflow for handling them efficiently and logging them into a `Google Sheet`
- Also I am using the `retry executions on failure` feature of the n8n HTTP Request node in the workflow, if it still fails to execute its task then it sends the output(error/succuss) to the further nodes
- Extended the `Create` branch with multple nodes that checks for any errors coming during executions in the `Create` branch and if that happens, the error or success executions are being logged into a google sheet using `Google Sheet` node
- Added some sticky notes in the workflow so that anyone new to this workflow can get an idea about the workflow and its node's working

### Changes
- `Create` branch has been modified with error handling and logging nodes.
 
## Version 3.0.1 (2025-11-12) 
**Author:** Abhishek Singh

### Added
- In this version I have impelemented the Error simulation and handling of **Payload Creation for HTTP Requests** in the further `create/update/delete` branches, aslo added a node to log this failure into a `Google Sheet`
- Extended the `Update` and `Delete` branches with error check nodes (`Is search succeeded? Update` and `Is search succeeded? Delete`) that check for any errors coming during executions in both the branches and if that happens, the error or success executions are being logged into a google sheet using `Google Sheet` node
- Added some sticky notes in the workflow so that anyone new to this workflow can get an idea about the workflow and its node's working

### Changes
- `Update` and `Delete` branches has been modified with error handling and logging nodes
- Also updateed the `Extract Req Id` nodes for both the update and delete branches to get the response of `Search HTTP Request` nodes


 
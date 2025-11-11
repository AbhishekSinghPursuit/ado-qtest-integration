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
 
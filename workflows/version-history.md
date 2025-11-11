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
 
## ADO - qTest Integration
This workflow shows how Azure DevOps automatically connects to qTest through n8n (the connecting technology) and then performs the tasks like `create/update/delete` requirements in a qTest project with its APIs. 

**In Simple Terms:**
- When you create a task in Azure DevOps Board → A requirement automatically appears in qTest 
- When you update the task → The requirement updates automatically 
- When you delete the task → The requirement gets removed automatically 
**No manual data entry. No copy-paste errors. No delays.** 

## Complete Implementation Guide
[ADO-qTest Integration Guide](https://pursuitsoftwarebiz-my.sharepoint.com/:w:/g/personal/abhishek_s_pursuitsoftware_com/ETiML2N9efVDr-Ykz3U49nsBbCte6L1nF4QmEL86MgrsnQ?e=S0J1hm)

## Version History
[workflows/Version-history](/workflows/version-history.md)

## Know about workflow
[Workflow Documentation](/docs/workflow-documentation.md)

## n8n workflow
**v3.0.2**
<img width="1669" height="943" alt="Screenshot 2025-11-17 110229" src="https://github.com/user-attachments/assets/625e5fc9-cdfe-454d-8acb-f853e60af5c6" />
**v3.0.0**
<img width="1800" height="868" alt="Screenshot 2025-11-13 101709" src="https://github.com/user-attachments/assets/7b1ceba1-6b97-4746-baf5-a5e6a5b27791" />
**v2.0.0**
<img width="1723" height="929" alt="Screenshot 2025-11-12 181345" src="https://github.com/user-attachments/assets/6fd7e52c-8ee5-4db9-8916-bd3339a4c811" />
**v1.0.0**
<img width="1509" height="425" alt="Screenshot 2025-11-11 113704" src="https://github.com/user-attachments/assets/c3d9d7ed-078e-4583-8434-5c43eb84f90f" />





## Workflow for Making Changes 

### If someone wants to add some changes here: 

1. Clone repository 
```bash
git clone https://github.com/AbhishekSinghPursuit/ado-qtest-integration.git 
cd ado-qtest-integration 
```
 
2. Create feature branch 
```bash
git checkout -b feature/multi-project-config 
```
 
3. Import current workflow from n8n (Only for self-hosted or cloud enterprise users)
```bash
./scripts/import-workflows.sh 
```
 
4. Make changes in n8n UI 
(Or edit JSON file directly if you're comfortable) 
 
5. Export updated workflow (Only for self-hosted or cloud enterprise users)
```bash
./scripts/export-workflows.sh 
```
 
6. Commit changes 
```bash
git add workflows/main-workflow.json 
git commit -m "feat: Add multi-project configuration support 
```
 
- Added configuration lookup node 
- Dynamic field mapping based on project 
- Support for multiple qTest instances" 
 
7. Push to remote 
```bash
git push origin feature/multi-project-config 
```
 
8. Create Pull Request on GitHub/GitLab

## Troubleshooting Guide
[docs/Troubleshoot](/docs/troubleshooting.md)

## Import Workflows from n8n
> **n8n API Key & curl (For automatic import):** Only for self-hosted or cloud enterprise users with elevated access. Not available to standard n8n Cloud users.

> **For n8n Cloud:** Use the web UI’s download/import features for workflow migration and manual version control.

```bash
./scripts/import-workflows.sh main-workflow.json
```

## Export Workflows to n8n
> **n8n API Key & curl (For automatic export):** Only for self-hosted or cloud enterprise users with elevated access. Not available to standard n8n Cloud users.

> **For n8n Cloud:** Use the web UI’s download/import features for workflow migration and manual version control.

```bash
chmod +x scripts/export-workflows.sh
./scripts/export-workflows.sh
```


### Project Structure
```text
ado-qtest-integration/ 
├── .gitignore 
├── README.md 
├── workflows/ 
│   ├── main-workflow.json 
│   ├── error-handling-workflow.json 
│   └── version-history.md 
├── credentials/ 
│   ├── credentials-template.json  (NO ACTUAL TOKENS) 
│   └── README.md 
├── docs/ 
│   ├── setup-guide.md 
│   ├── troubleshooting.md 
│   └── architecture.md 
└── scripts/ 
    ├── export-workflows.sh 
    ├── import-workflows.sh 
    └── validate-workflow.js
```

## Contributing
* Fork the repository.
* Create a new branch (`git checkout -b feature-branch`).
* Make your changes.
* Commit your changes (`git commit -m 'Add some feature`).
* Push to the branch (`git push origin feature-branch`).
* Open a pull request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact Me
For any inquiries or support, please reach out to:

* **Author:** [Abhishek Singh](https://github.com/SinghIsWriting/)
* **LinkedIn:** [My LinkedIn Profile](https://www.linkedin.com/in/abhishek-singh-bba2662a9)
* **Portfolio:** [Abhishek Singh Portfolio](https://portfolio-abhishek-singh-nine.vercel.app/)

## ADO - qTest Integration

## Complete Implementation Guide
[ADO-qTest Integration Guide](https://pursuitsoftwarebiz-my.sharepoint.com/:w:/g/personal/abhishek_s_pursuitsoftware_com/ETiML2N9efVDr-Ykz3U49nsBbCte6L1nF4QmEL86MgrsnQ?e=S0J1hm)

## n8n workflow
<img width="1616" height="850" alt="Screenshot 2025-10-31 180907" src="https://github.com/user-attachments/assets/dcb730a7-84df-4101-a10b-1b4ff42553c4" />


## Workflow for Making Changes 

### Developer A wants to add multi-project support: 

1. Clone repository 
```bash
git clone https://github.com/AbhishekSinghPursuit/ado-qtest-integration.git 
cd ado-qtest-integration 
```
 
2. Create feature branch 
```bash
git checkout -b feature/multi-project-config 
```
 
3. Export current workflow from n8n 
```bash
./scripts/export-workflows.sh 
```
 
4. Make changes in n8n UI 
(Or edit JSON file directly if you're comfortable) 
 
5. Export updated workflow 
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

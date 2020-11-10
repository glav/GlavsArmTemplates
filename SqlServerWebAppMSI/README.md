# Sql Server + database + Web App Service all using Managed Identity
This Azure CLI script will create a both a Web App (AppService) with a managed identity, a SQL server and database , and ensures the managed identity is in the requisite group for access to the database

 
## What it does
It will perform the following:
- Creates a resource group
- Creates an App service plan (linux) and app service with a managed identity
- Creates a SQL Server with a SQL database 
- Assigns Admin access to the nominated Azure AD Group
- Adds the web app managed identity to the Azure AD Admin group

## Usage
- create.ps1 -dbadminpassword  "YourAdminPassword"

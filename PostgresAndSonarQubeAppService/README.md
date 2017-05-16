# Linux AppService and Linux AppService for SonarQube
This ARM template will create both a Linux AppService, Linux Postgres AppService instance, and setup the service to use the SonarQube docker container from DockerHub which connects to the Postgres app service instance.

## What it does
It will perform the following:
- Create a resource group
- Create a Linux based AppService plan
- Create a Linux Postgres appService
- Create an AppService (B2 - minimum required as it has 3.5Gb memory)
- Configure the AppService to pull the SonarQube image from dockerHub
- Configures the AppService sonarqube docker instance to use the postgres SQL database on the AppService as its datastore.

## Usage
- Change the WebSite.parameters.json file to suit. There are some plain text username/passwords in there. Dont use those! :-)
- Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation "West US" -ResourceGroupName "SonarQube"

Note: Currently, only "West US", "West Europe" and "Southeast Asia" is supported regions as Linux app service is currently in preview. [See here](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-intro)

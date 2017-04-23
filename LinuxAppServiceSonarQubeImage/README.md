# Linux AppService and SonarQube
This ARM template will create a Linux AppService and setup the service to use the SonarQube docker container from DockerHub.

## What it does
It will perform the following:
- Create a resource group
- Create a Linux based AppService plan
- Create an AppService (B2 - minimum required as it has 3.5Gb memory)
- Configure the AppService to pull the SonarQube image from dockerHub
- Create an AppInsights service with a simple alert to monitor the AppService.

## Usage
- Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation "West US" -ResourceGroupName "SonarQube"

Note: Currently, only "West US", "West Europe" and "Southeast Asia" is supported regions as Linux app service is currently in preview. [See here](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-intro)

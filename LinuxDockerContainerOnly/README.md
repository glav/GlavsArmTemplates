# Linux AppService and SonarQube
This ARM template will create a Linux AppService and setup the service to use the SonarQube docker container from DockerHub.

## What it does
It will perform the following:
- Create a resource group
- Create a Linux based AppService plan
- Create an AppService (B2 - minimum required as it has 3.5Gb memory)
- Configure the AppService to pull the SonarQube image from dockerHub

## Usage
- Change the WebSite.parameters.json file to suit. There are some plain text username/passwords in there. Dont use those! :-)
- Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation "West US" -ResourceGroupName "SonarQube"


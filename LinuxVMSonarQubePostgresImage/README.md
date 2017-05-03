# Linux AppService and SonarQube
This ARM template will create a Linux AppService and setup the service to use the SonarQube docker container from DockerHub.

## What it does
It will perform the following:
- Create a resource group
- Create a Linux based AppService plan
- Create a Network interface, public IP address, network security group and VNET.
- Creates a managed disk of 30Gb in size.
- Create a Virtual machine with a docker extension configured to run postgres SQL (via dockerhub image - vmSize set to Standard_D1_v2)
- Hooks up the Virtual machine to the network resources and disk created previously.
- Create an AppService (B2 - minimum required as it has 3.5Gb memory)
- Configure the AppService to pull the SonarQube image from dockerHub
- Configures the AppService sonarqube docker instance to use the postgres SQL database as its datastore.

## Usage
- Change the WebSite.parameters.json file to suit. There are some plain text username/passwords in there. Dont use those! :-)
- Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation "West US" -ResourceGroupName "SonarQube"

Note: Currently, only "West US", "West Europe" and "Southeast Asia" is supported regions as Linux app service is currently in preview. [See here](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-intro)

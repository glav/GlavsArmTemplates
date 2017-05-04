# Linux AppService and SonarQube
This ARM template will create a Linux AppService and setup the service to use the SonarQube docker container from DockerHub.

## What it does
It will perform the following:
- Create a resource group
- Create a Network interface, public IP address, network security group and VNET.
- Creates a managed disk of 30Gb in size.
- Create a Virtual machine with a docker extension configured to run postgres SQL and also SonarQube via dockerhub image (vmSize set to Standard_D2_v2)
- Hooks up the Virtual machine to the network resources and disk created previously.

## Usage
- Change the WebSite.parameters.json file to suit. There are some plain text username/passwords in there. Dont use those! :-)
- Deploy-AzureResourceGroup.ps1 -ResourceGroupLocation "West US" -ResourceGroupName "SonarQube"

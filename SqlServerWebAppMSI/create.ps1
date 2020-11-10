param(
[Parameter(Mandatory = $true)]
[string]
$dbadminpassword
)
#This script does the following:
#  Creates a resource group
#  Creates an App service plan (linux) and app service with a managed identity
#  Creates a SQL Server with a SQL database 
#  Assigns Admin access to the nominated Azure AD Group
#  Adds the web app managed identity to the Azure AD Admin group

$rg="sqlmsi-test"
$loc="AustraliaEast"
$app="sqlmsiwebapp"
$env="dev"
$owner="Donald Duck"
$tags=@("application=sqlmsi","environment=$env","owner=$owner")
$appname=$app+$env
$appplan=$appname+"plan"

$dbadminuser="someadmin"
$dbserver="sqlmsisqlserver"+$env
$dbsqlname="sqlmsisqldb"+$env
$adGroupNameForAdmin= "SQLAdmins"

Write-Host "Creating resource group $rg" -ForegroundColor White
$rgResults=az group create --name $rg -l $loc --tags $tags

Write-Host "Creating AppService plan $appplan" -ForegroundColor White
$appPlanResults=az appservice plan create -n $appplan --sku F1 --is-linux --tags "sqlmsi" --resource-group $rg

Write-Host "Creating AppService web app $appname" -ForegroundColor White
#Need to turn off evaluation using --% otherwise the it reports error due to runtime and |
$webappresponse=az webapp create -n $appname -p $appplan -g $rg --assign-identity "[system]" --% --runtime "DOTNETCORE|3.1" 
$webappprops=$webappresponse|ConvertFrom-Json

Write-Host "Creating SQL Server $dbserver" -ForegroundColor White
$dbserverresponse=az sql server create -g $rg -l $loc --admin-password $dbadminpassword --admin-user $dbadminuser --name $dbserver --assign-identity
$dbserverprops=$dbserverresponse|ConvertFrom-Json

Write-Host "Creating SQL Database $dbsqlname" -ForegroundColor White
#2vcores / capacity for dev - zone redundant not supported for AustraliaEast in this config
$dbsqlresponse=az sql db create -n $dbsqlname -g $rg --server $dbserver --compute-model serverless --edition GeneralPurpose --family Gen5 --capacity 2
$dbsqlprops=$dbsqlresponse|ConvertFrom-Json

Write-Host "Searching for Active Directory group to setup as admins: $adGroupNameForAdmin" -ForegroundColor White
$groupFound=az ad group list --query "[?displayName=='$adGroupNameForAdmin'].{name:displayName, objectId:objectId, userPrincipalName:userPrincipalName}" | ConvertFrom-Json

if ( $null -ne $groupFound ) 
{
    Write-Host "Adding AD Group " $groupFound.name " as Administrators" -ForegroundColor White
    az sql server ad-admin create --display-name $groupFound.name --object-id $groupFound.objectId -g $rg --server $dbserver -o none 

    Write-Host "Adding WebApp managed identity to SQLGroup to allow access" -ForegroundColor White
    az ad group member add --group $groupFound.objectId --member-id $webappprops.identity.principalId -o none

    Write-Host ""
    Write-Host "Note: You still need to make change to the SQL database to allow access for the Service Principal managed identity." -ForegroundColor White
    Write-Host "See: https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-connect-msi#modify-aspnet-core" -ForegroundColor White
    Write-Host ""
    Write-Host "SQL Required:" -ForegroundColor Gray
    Write-host "CREATE USER [" $groupFound.name "] FROM EXTERNAL PROVIDER;" -ForegroundColor Yellow
    Write-host "ALTER ROLE db_datareader ADD MEMBER [" $groupFound.name "];" -ForegroundColor Yellow
    Write-host "ALTER ROLE db_datawriter ADD MEMBER [" $groupFound.name "];" -ForegroundColor Yellow
    Write-host "ALTER ROLE db_ddladmin ADD MEMBER [" $groupFound.name "];" -ForegroundColor Yellow
    Write-host "GO" -ForegroundColor Yellow

}

Write-Host ""
Write-Host "Done"








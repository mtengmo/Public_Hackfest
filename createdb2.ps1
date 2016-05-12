#param ([string]$databaseName, [string]$databasePassword,     [string]$sqlInstanceName)

function CreateSQLUser([string]$instanceName, [string]$dbName, [string]$dbPassword)
{
    $dbServer = New-Object Microsoft.SqlServer.Management.Smo.Server $instanceName
    if ($dbServer.Logins.Contains($dbName))  
    {   
       Write-Host "##############ToDo: User should be deleted####################"
       return
    }
    
    $login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $instanceName, $dbName
    $login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
    $login.PasswordExpirationEnabled = $false
    $login.DefaultDatabase = $dbName
    $login.Create($dbPassword)

}


Import-Module SQLPS -DisableNameChecking
 
'$sqlInstanceName = "localhost"
'$databaseName = "identitytest"
'$dbPassword = "Agresso1"

'$srvr = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $sqlInstanceName


'$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($srvr, $databaseName)
$db.Create()

CreateSQLUser -instanceName $sqlInstanceName -dbName $databaseName -dbPassword $dbPassword 

$db.SetOwner($databaseName)

$db.RecoveryModel = 'Simple'
$db.Alter()
 
#Confirm, list databases in your current instance
$srvr.Databases |
Select Name, Status, Owner, CreateDate
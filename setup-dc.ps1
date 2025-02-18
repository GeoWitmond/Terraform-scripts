param (
    [string]$DomainName,
    [string]$NetbiosName,
    [string]$AdminPassword
)

# Installeer de Active Directory en DNS rollen
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Converteer het wachtwoord naar een SecureString
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force

# Promoot de server tot Domain Controller
Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetbiosName -SafeModeAdministratorPassword $SecurePassword -InstallDns -Force

# Herstart de machine
Restart-Computer -Force

param (
    [string]$DomainName,
    [string]$NetbiosName,
    [string]$SafeModePassword
)

# Install AD Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Convert password to a Secure String
$SecureSafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

# Promote server to Domain Controller
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -SafeModeAdministratorPassword $SecureSafeModePassword `
    -Force `
    -NoRebootOnCompletion

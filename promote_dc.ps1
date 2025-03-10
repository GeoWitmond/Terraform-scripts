param (
    [string]$DomainName,
    [string]$NetbiosName,
    [string]$SafeModePassword,
    [bool]$IsFirstDC,
    [string]$DomainAdminUser,
    [string]$DomainAdminPassword
)

# Convert passwords to Secure Strings
$SecureSafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force
$SecureDomainAdminPassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
$DomainAdminCredentials = New-Object System.Management.Automation.PSCredential("$DomainName\$DomainAdminUser", $SecureDomainAdminPassword)

# Install AD Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

if ($IsFirstDC) {
    Write-Host "Configuring first Domain Controller in new forest: $DomainName"

    # Promote to first Domain Controller
    Install-ADDSForest `
        -DomainName $DomainName `
        -DomainNetbiosName $NetbiosName `
        -SafeModeAdministratorPassword $SecureSafeModePassword `
        -Force `
        -NoRebootOnCompletion
} else {
    Write-Host "Adding this server as a Replica Domain Controller to domain: $DomainName"

    # Promote to Replica DC
    Install-ADDSDomainController `
        -DomainName $DomainName `
        -Credential $DomainAdminCredentials `
        -SafeModeAdministratorPassword $SecureSafeModePassword `
        -Force `
        -NoRebootOnCompletion
}

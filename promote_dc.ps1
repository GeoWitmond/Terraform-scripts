param (
    [string]$DomainName,
    [string]$NetbiosName,
    [string]$SafeModePassword,
    [bool]$IsFirstDC
)

# Convert password to a Secure String
$SecureSafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

if ($IsFirstDC) {
    Write-Host "Configuring first Domain Controller in new forest: $DomainName"

    # Install AD DS role
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

    # Promote to first Domain Controller
    Install-ADDSForest `
        -DomainName $DomainName `
        -DomainNetbiosName $NetbiosName `
        -SafeModeAdministratorPassword $SecureSafeModePassword `
        -Force `
        -NoRebootOnCompletion
}
else {
    Write-Host "Adding this server as a Replica Domain Controller to domain: $DomainName"

    # Install AD DS role
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

    # Promote to Replica DC
    Install-ADDSDomainController `
        -DomainName $DomainName `
        -Credential (Get-Credential -UserName "$DomainName\Administrator" -Message "Enter domain admin credentials") `
        -SafeModeAdministratorPassword $SecureSafeModePassword `
        -Force `
        -NoRebootOnCompletion
}

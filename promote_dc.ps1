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

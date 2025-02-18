param (
    [string]$DomainName,
    [string]$DomainUser,
    [string]$DomainPassword
)

# Converteer het wachtwoord naar een SecureString
$SecurePassword = ConvertTo-SecureString $DomainPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($DomainUser, $SecurePassword)

# Voeg de machine toe aan het domein
Add-Computer -DomainName $DomainName -Credential $Credential -Restart -Force

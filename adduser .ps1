## Find all HTTPS listners
$httpsListeners = Get-ChildItem -Path WSMan:\localhost\Listener\ | where-object { $_.Keys -match 'Transport=HTTPS' }

## If not listeners are defined at all or no listener is configured to work with
## the server cert created, create a new one with a Subject of the computer's host name
## and bound to the server certificate.
if ((-not $httpsListeners) -or -not (@($httpsListeners).where( { $_.CertificateThumbprint -ne $serverCert.Thumbprint }))) {
    $newWsmanParams = @{
        ResourceUri = 'winrm/config/Listener'
        SelectorSet = @{ Transport = "HTTPS"; Address = "*" }
        ValueSet    = @{ Hostname = $hostName; CertificateThumbprint = $serverCert.Thumbprint }
        # UseSSL = $true
    }
    $null = New-WSManInstance @newWsmanParams
}

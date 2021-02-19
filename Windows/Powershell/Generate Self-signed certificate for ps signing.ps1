Get-ChildItem -Path "Cert:\CurrentUser\Root"
Get-ChildItem -Path "Cert:\LocalMachine\Root"

Set-ExecutionPolicy Unrestricted

# Create a certificate to use for signing powershell scripts
$selfsigncert = New-SelfSignedCertificate `
                -Subject "CN=PowerShell Code Signing" `
                -KeyAlgorithm RSA `
                -KeyLength 2048 `
                -Type CodeSigningCert `
                -CertStoreLocation Cert:\LocalMachine\My\

# Move the root cert into Trusted Root CAs
Move-Item "Cert:\LocalMachine\My\$($selfsigncert.Thumbprint)" Cert:\LocalMachine\Root

# Obtain a reference to the code signing cert in Trusted Root
$selfsignrootcert = Get-ChildItem -Path "Cert:\LocalMachine\Root\$($selfsigncert.Thumbprint)" -CodeSigningCert

#OR
## Get Root CA thumbprint
#Get-ChildItem -Path "Cert:\LocalMachine\Root\" #now lookup for "CN=PowerShell Code Signing" thumbprint value and copy it in below leaf level path
#$selfsignrootcert = Get-ChildItem -Path "Cert:\LocalMachine\Root\76816FA03E011881EB0693F2B4BA66302B7311EE" -CodeSigningCert

# Sign script
Set-AuthenticodeSignature MoveFiles.ps1 $selfsignrootcert
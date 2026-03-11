# Generate Android keystore based on android/key.properties or interactive input
# Usage: .\scripts\generate_keystore.ps1 [-Yes]
# If -Yes is provided the script will not prompt for confirmation when overwriting.

param(
    [switch]$Yes
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = (Resolve-Path "$ScriptDir\..").Path
$KeyPropsFile = Join-Path $ProjectRoot "android\key.properties"

# Default output
$StoreFileRel = "android\upload-keystore.jks"
$StoreFile    = Join-Path $ProjectRoot $StoreFileRel

# Load from key.properties if it exists
$StorePassword = ""
$KeyPassword   = ""
$KeyAlias      = ""

if (Test-Path $KeyPropsFile) {
    Write-Host "Found $KeyPropsFile, parsing..."
    Get-Content $KeyPropsFile | ForEach-Object {
        if ($_ -match '^(storePassword|keyPassword|keyAlias|storeFile)\s*=\s*(.+)$') {
            $k = $Matches[1].Trim()
            $v = $Matches[2].Trim()
            switch ($k) {
                "storePassword" { $StorePassword = $v }
                "keyPassword"   { $KeyPassword   = $v }
                "keyAlias"      { $KeyAlias       = $v }
                "storeFile"     {
                    # If storeFile is not an absolute path, treat as relative to android/
                    if ([System.IO.Path]::IsPathRooted($v)) {
                        $StoreFile = $v
                    } else {
                        $StoreFile = Join-Path $ProjectRoot "android\$v"
                    }
                }
            }
        }
    }
}

# Prompt for missing values
function Read-ValueIfEmpty {
    param([string]$Current, [string]$Prompt)
    if ([string]::IsNullOrWhiteSpace($Current)) {
        return (Read-Host $Prompt)
    }
    return $Current
}

$StorePassword = Read-ValueIfEmpty $StorePassword "Keystore password (storePassword)"
$KeyPassword   = Read-ValueIfEmpty $KeyPassword   "Key password (keyPassword)"
$KeyAlias      = Read-ValueIfEmpty $KeyAlias      "Key alias (keyAlias)"

# Confirm overwrite
if (Test-Path $StoreFile) {
    if (-not $Yes) {
        $yn = Read-Host "Keystore file $StoreFile already exists. Overwrite? (y/N)"
        if ($yn -notmatch '^[Yy]') {
            Write-Host "Aborted."
            exit 1
        }
    } else {
        Write-Host "Overwriting existing keystore: $StoreFile"
    }
}

# Ensure directory exists
$StoreDir = Split-Path -Parent $StoreFile
if (-not (Test-Path $StoreDir)) {
    New-Item -ItemType Directory -Path $StoreDir | Out-Null
}

# Distinguished Name
$DefaultDName = "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=CN"
$DNameIn = Read-Host "Distinguished Name for key (DN) [default: $DefaultDName]"
if ([string]::IsNullOrWhiteSpace($DNameIn)) {
    $DName = $DefaultDName
} else {
    $DName = $DNameIn
}

# Check keytool
if (-not (Get-Command keytool -ErrorAction SilentlyContinue)) {
    Write-Error "Error: keytool not found. Please ensure JDK is installed and keytool is in PATH."
    exit 2
}

# Generate keystore
Write-Host "Generating keystore at: $StoreFile"

keytool -genkeypair `
    -alias       $KeyAlias `
    -keyalg      RSA `
    -keysize     2048 `
    -validity    10000 `
    -keystore    $StoreFile `
    -storetype   JKS `
    -dname       $DName `
    -storepass   $StorePassword `
    -keypass     $KeyPassword `
    -v

if ($LASTEXITCODE -eq 0) {
    Write-Host "Keystore generated: $StoreFile"
    Write-Host "(If you used passwords in key.properties, that file now contains the credentials.)"
} else {
    Write-Error "keytool failed"
    exit 3
}

# Set restrictive permissions (owner read/write only)
try {
    $Acl = Get-Acl $StoreFile
    $Acl.SetAccessRuleProtection($true, $false)  # disable inheritance
    $Acl.Access | ForEach-Object { $Acl.RemoveAccessRule($_) | Out-Null }
    $Rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
        "FullControl",
        "Allow"
    )
    $Acl.AddAccessRule($Rule)
    Set-Acl -Path $StoreFile -AclObject $Acl
} catch {
    Write-Warning "Could not set restrictive permissions on keystore: $_"
}

Write-Host @"

Next steps:
- Commit the keystore to a secure location (avoid committing to git). Prefer storing in secure storage or CI secrets.
- Ensure android/key.properties is kept out of source control (.gitignore) or encrypted.
- To run non-interactively: .\scripts\generate_keystore.ps1 -Yes
"@


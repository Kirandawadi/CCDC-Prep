#Works only for Windows SSH configurations
#Script to rewrite the sshd_config file to secure the SSH server
#Based on testing, prepending the proper configuration to the start of the sshd_config file,
#the service reads the first instance and sets that value. Further changes are not implemented,
#i.e., the first time a configuration is specified, it is locked.
#Crude way to do it, instead of replacing it with a secure configuration file, but it works.


#Default path on Windows to sshd_config
$sshdConfig = "C:\ProgramData\ssh\sshd_config"

#Defines the hardening configuration
$secureConfig = "AllowTCPForwarding no
ChallengeResponseAuthentication no
ClientAliveCountMax 0
ClientAliveInterval 300
HostbasedAuthentication no
IgnoreRhosts yes
LoginGraceTime 60
LogLevel VERBOSE
MaxAuthTries 3
MaxSessions 2
PermitEmptyPasswords no
PermitRootLogin no
PermitUserEnvironment no
Protocol 2
PubkeyAuthentication no
StrictModes yes
X11Forwarding no
"

#Check if the script is running as Administrator
$admin = [bool]((whoami /groups) -match "S-1-16-12288")
if (-not $admin)
{
    Write-Host "Not running as Administrator. Please restart PowerShell as Administrator."
    exit 1
}

#Checks if ssh is running on the machine
$sshdStatus = Get-Service -Name sshd -ErrorAction SilentlyContinue
if ($sshdStatus.Status -ne 'Running')
{
    echo "sshd service is not running or not installed on this machine. Quitting."
    exit 1
}

#Saves the original configuration
$newConfig = $secureConfig + " " + (Get-Content $sshdConfig -Raw)
#Removes the ssh server configuration file
rm $sshdConfig
#Echos the new configurations into the new file
Set-Content -Value $newConfig -Path $sshdConfig -Encoding utf8

#Restarts the OpenSSH service to apply the secured changes
Restart-Service sshd
#Verify SSH service status
$sshdStatus = Get-Service sshd | Select-Object -ExpandProperty Status
if ($sshdStatus -eq "Running")
{
    echo "Successsfully restarted sshd service."
}
else
{
    echo "sshd service is not running."
}
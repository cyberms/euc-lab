# Workaround for Sysprep
# https://docs.microsoft.com/en-us/answers/questions/596112/windows-111-mdt-sysprep-failure-onedrive.html?page=2&pageSize=10&sort=oldest

#OneDrive
Get-AppxPackage *OneDriveSync* | Remove-AppxPackage


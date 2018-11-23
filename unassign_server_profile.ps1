# Unassign the ServerProfile and delete the server profile, if the migration from one network to another network failed. 
if (-not (get-module HPOneView.400))
{
	import-Module HPOneView.400
}
if (-not $connectedsessions)
{
	$appliance='10.41.240.57'
	$username='Administrator'
	$Password='Password@123'
	$ApplianceConnection=Connect-HPOVMgmt -Hostname $appliance -Username $username -Password $password
}
Get-HPOVServerProfile -Name "HOS8*" -OutVariable hos8
foreach ($element in $hos8.name)
{
    $profile=Get-HPOVServerProfile -Name $element
    $profile.serverHardwareUri=""
    $profile.enclosureUri=""
    $profile.enclosureBay=""
    Set-HPOVResource $profile
    $task = Remove-HPOVServerProfile -ServerProfile $profile -Force -Confirm:$false | Wait-HPOVTaskComplete
}

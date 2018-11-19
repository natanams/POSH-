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
$tasks = Get-HPOVStorageVolume | Remove-HPOVStorageVolume -Confirm:$false | wait-HPOVTaskComplete
$tasks = Get-HPOVStoragePool | Remove-HPOVStoragePool -Confirm:$false | Wait-HPOVTaskComplete
$tasks = Get-HPOVStorageSYstem | Remove-HPOVStorageSystem -Force -Confirm:$false | Wait-HPOVTaskComplete
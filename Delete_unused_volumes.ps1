#Delete the Volumes that have been successfully disconnected from servers and no-longer needed for data.
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
Get-HPOVStorageVolume -Name "HOS7*" -OutVariable hos7v
foreach ($element in $hos7v.name)
{
    $myvol=Get-HPOVStorageVolume -Name $element
    $Task = Remove-HPOVStorageVolume -InputObject $myvol -Confirm:$false | Wait-HPOVTaskComplete
}
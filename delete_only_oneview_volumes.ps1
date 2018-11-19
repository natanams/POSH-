Import-Module HPOneView.400
if (-not $connectedsessions)
{
	$appliance='10.41.240.57'
	$username='Administrator'
	$Password='Password@123'
	$ApplianceConnection=Connect-HPOVMgmt -Hostname $appliance -Username $username -Password $password
}
$myvolume=Get-HPOVStorageVolume -Name "*DELTEST*"
foreach ($element in $myvolume.name)
{
    $delvolume=Get-HPOVStorageVolume -Name $element
    Remove-HPOVStorageVolume -InputObject $delvolume -ExportOnly -Confirm:$false
}
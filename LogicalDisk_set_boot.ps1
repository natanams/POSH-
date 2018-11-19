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
Get-HPOVServerProfile -Name "HOS8*" -outvariable server
foreach ($element in $server.name)
{
    $myprofile=Get-HPOVServerProfile -Name $element
    New-HPOVServerProfileLogicalDisk -Name RAID -Bootable $True -DriveType SAS -NumberofDrives 2 -RAID RAID1
}

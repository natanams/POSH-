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
Write-Host 'The LIst of enclosures managed by this appliance'
Get-HPOVEnclosure
Write-Host 'The servers managed by this appliance'
Get-HPOVServer
Write-Host 'Create Volumes from Templates and attach it to the Servers'
$storagePool='HOS_RAID5_10K'
$storagesystem = Get-HPOVStorageSystem -Name 'P7400_N19U22'
Get-HPOVServerProfile -Name "HOS3*" -outvariable server
$hostOStype='RHE Linux'
foreach ($element in $server.name)
{
    write $element
    $vol1=($element+"-DELTEST1")
    New-HPOVStorageVolume -Name $vol1 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
    $volume1 = Get-HPOVStorageVolume -Name $vol1
    $myprofile = Get-HPOVServerProfile -Name $element
    New-HPOVServerProfileAttachVolume -ServerProfile $myprofile -Volume $volume1 -VolumeID 0 
}
Start-sleep 150
Get-HPOVServerProfile -Name "HOS3*" -outvariable server
foreach ($element in $server.name)
{
    write $element
    $vol2=($element+"-DELTEST2")
    New-HPOVStorageVolume -Name $vol2 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
    $volume2 = Get-HPOVStorageVolume -Name $vol2
    $myprofile = Get-HPOVServerProfile -Name $element
    #New-HPOVServerProfileAttachVolume -ServerProfile $myprofile -Volume $volume2 -VolumeID 0 
}
Start-sleep 150
Get-HPOVServerProfile -Name "HOS3*" -outvariable server
foreach ($element in $server.name)
{
    write $element
    $vol3=($element+"-DELTEST3")
    New-HPOVStorageVolume -Name $vol3 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
    $volume3 = Get-HPOVStorageVolume -Name $vol3
    $myprofile = Get-HPOVServerProfile -Name $element
    #New-HPOVServerProfileAttachVolume -ServerProfile $myprofile -Volume $volume3 -VolumeID 0 
}
Start-sleep 150
Get-HPOVServerProfile -Name "HOS3*" -outvariable server
foreach ($element in $server.name)
{
    write $element
    $vol4=($element+"-DELTEST4")
    New-HPOVStorageVolume -Name $vol4 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
    $volume4 = Get-HPOVStorageVolume -Name $vol4
    $myprofile = Get-HPOVServerProfile -Name $element
    #New-HPOVServerProfileAttachVolume -ServerProfile $myprofile -Volume $volume4 -VolumeID 0 
}

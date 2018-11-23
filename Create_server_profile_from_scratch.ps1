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
Get-HPOVServer -Name "C7000U7U31*" -OutVariable encl | sort Position
$totalcount = $encl.Count
write "totalCount :$totalcount"
$storagePool='HOS_RAID5_10K'
$storagesystem = Get-HPOVStorageSystem -Name 'P7400_N19U22'
$count=1
$myenclosure = Get-HPOVEnclosure -Name "C7000U7U31"
$myhardware = Get-HPOVServerHardwareType
#write "Enclosure : $myenclosure"
#write "Hardware type: $myhardware"
    foreach($element in $encl.name)
    {
        if($count -lt 10)
        {
            $profileName="HOS8-U7U31-B0"+"$count"
        }
        elseif($count -ge 10)
        {
            $profileName="HOS8-U7U31-B"+"$count"
        }
        #$profileName = "HOS8-U7U31-B01"
        #write "Profile: $profileName"
        #write "Element: $element"
        $server = Get-HPOVServer -Name "C7000U7U31, bay $count" -NoProfile | sort Position
        $myhardware = Get-HPOVServerHardwareType -Name "*460*"
        #write "Server : $server"
        if ($count -eq 1)
        {
            $con1=Get-HPOVNetworkSet -Name "hos8_bond0" | New-HPOVServerProfileConnection -Name "hos8_bond0" -ConnectionID 1 -ConnectionType Ethernet
        }
        else
        {
            $con1=Get-HPOVNetworkSet -Name "hos8_bond0" | New-HPOVServerProfileConnection -Name "hos8_bond0" -ConnectionID 1 -ConnectionType Ethernet -Bootable -Priority Primary
        
        }
        $con2=Get-HPOVNetworkSet -Name "hos8_bond0" | New-HPOVServerProfileConnection -Name "hos8_bond1" -ConnectionID 2 -ConnectionType Ethernet
        $con3=Get-HPOVNetwork -Name "SAN_A" | New-HPOVServerProfileConnection -Name "SAN_A" -ConnectionID 3 -ConnectionType FibreChannel
        $con4=Get-HPOVNetwork -Name "SAN_B" | New-HPOVServerProfileConnection -Name "SAN_B" -ConnectionID 4 -ConnectionType FibreChannel
        $conlist= ($con1, $con2, $con3, $con4)
        $vol1=($profileName+"-VOL1")
        $vol2=($profileName+"-VOL2")
        $vol3=($profileName+"-VOL3")
        $vol4=($profileName+"-VOL4")
        New-HPOVStorageVolume -Name $vol1 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
        New-HPOVStorageVolume -Name $vol2 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
        New-HPOVStorageVolume -Name $vol3 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
        New-HPOVStorageVolume -Name $vol4 -StoragePool $storagepool -ApplianceConnection $appliance -Capacity 1024 -ProvisioningType Thin -StorageSystem $storagesystem
        $volume1 = Get-HPOVStorageVolume -Name $vol1 | New-HPOVServerProfileAttachVolume -volumeid 0
        $volume2 = Get-HPOVStorageVolume -Name $vol2 | New-HPOVServerProfileAttachVolume -volumeid 1
        $volume3 = Get-HPOVStorageVolume -Name $vol3 | New-HPOVServerProfileAttachVolume -volumeid 2
        $volume4 = Get-HPOVStorageVolume -Name $vol4 | New-HPOVServerProfileAttachVolume -volumeid 3
        $attachvolumes=@($volume1,$volume2,$volume3,$volume4)
        $bootorder = @("HardDisk","PXE")
        $localdisk = New-HPOVServerProfileLogicalDisk -Name "Raid1" -RAID RAID1 -NumberofDrives 2 -DriveType SAS -Bootable:$True
        $controller = New-HPOVServerProfileLogicalDiskController -ControllerID Embedded -Mode RAID -Initialize -LogicalDisk $localdisk
        $mydisk = @($localdisk)
        #write "Local Disk : $Localdisk "
        New-HPOVServerProfile -name $profileName -AssignmentType Server -Server $server -Connections $conlist -LocalStorage:$True -StorageController $controller  -SanStorage -HostOStype RHEL -StorageVolume $attachvolumes -ManageBoot -BootMode BIOS -BootOrder $bootorder -Confirm:$false | Wait-HPOVTaskComplete
        $count = $count + 1
        write "Current Count : $count"
        Start-Sleep 300
    }

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
	$vol1=($element+"-VOL1")
	#$vol2=($element+"-VOL2")
	#$vol3=($element+"-VOL3")
	#$vol4=($element+"-VOL4")
	Try
	{
		New-HPOVStorageVolume -StorageSystem $storagesystem -name $vol1 -Pool $StoragePool -Size 1024 
		#New-HPOVStorageVolume -StorageSystem $storagesystem -name $vol2 -Pool $StoragePool -Size 1024
		#New-HPOVStorageVolume -StorageSystem $storagesystem -name $vol3 -Pool $StoragePool -Size 1024
		#New-HPOVStorageVolume -StorageSystem $storagesystem -name $vol4 -Pool $StoragePool -Size 1024
	
		#$volume1=Get-HPOVStorageVolume -Name $vol1 | New-HPOVServerProfileAttachVolume -volumeid 1 
		#$volume2=Get-HPOVStorageVolume -Name $vol2 | New-HPOVServerProfileAttachVolume -volumeid 2 
		#$volume3=Get-HPOVStorageVolume -Name $vol3 | New-HPOVServerProfileAttachVolume -volumeid 3 
		#$volume4=Get-HPOVStorageVolume -Name $vol4 | New-HPOVServerProfileAttachVolume -volumeid 4 
		#$attachvolumes=@($vol1)
		#$task = Save-HPOVProfile -name $element -StorageVolume($attachvolumes)
		$Task = New-HPOVServerProfileAttachVolume -ServerProfile $server -Name $vol1 -Volume $vol1 -ApplianceConnection $appliance -Verbose| Wait-HPOVTaskComplete
	}
	catch
	{ 
		Write-error -ErrorRecord $_
	}
}

##Variables to be edited ##

$vcenter_server ="192.168.102.102"

$vcenter_user ="administrator@vsphere.local"

$vcenter_pwd =""

$Hostesxi = "192.168.102.103"

$VMsource = "Micro"

$ResPool = "Demo"

$DataStore = "1TBSSD3"

$VmDS = 'Home_Networks'
$VmInt1 = 'H102'
$VmInt2 = 'H101'


## Variables that do not need to be changed.

$VMclone1 = "k8-master"
$VMclone2 = "adservice"
$VMclone3 = "cartservice"
$VMclone4 = "checkoutservice"
$VMclone5 = "currencyservice"
$VMclone6 = "emailservice"
$VMclone7 = "frontend"
$VMclone8 = "loadgenerator"
$VMclone9 = "paymentservice"
$VMclone10 = "productcatalogservice"
$VMclone11 = "recommendationservice"
$VMclone12 = "redis-cart"
$VMclone13 = "shippingservice"

$dateofclone = date

## support unsigned certs
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers

##Connect to vCenter
connect-viserver -server $vcenter_server -User $vcenter_user -Password $vcenter_pwd

##Clone VM section

## create the resourcepool
New-ResourcePool -Location $Hostesxi -Name $ResPool 
$location = Get-ResourcePool | where { $_.Name -eq $ResPool }

$storeDisk = Get-Datastore -VMHost $Hostesxi | where { $_.Name -eq $DataStore }


##Clone VM to the ResourcePool

New-VM -VM $VMsource -Name $VMclone1 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace -  elk/docker root/docker" -RunAsync
New-VM -VM $VMsource -Name $VMclone2 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone3 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone4 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone5 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone6 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone7 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone8 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone9 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone10 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone11 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace" -RunAsync
New-VM -VM $VMsource -Name $VMclone12 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace"
New-VM -VM $VMsource -Name $VMclone13 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "Clone MicroApp $dateofclone by Toby Makepeace"


## Set the networks you want to deploy to 
$vdSwitch = Get-VDSwitch -Name $VmDS
$vdPortGroup1 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt1
$vdPortGroup2 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt2


##Set Network Adapter source VM
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone1 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone1 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone2 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone2 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone3 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone3 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone4 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone4 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone5 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone5 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone6 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone6 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone7 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone7 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone8 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone8 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone9 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone9 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone10 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone10 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone11 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone11 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone12 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone12 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False

Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone13 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone13 | where {$_.Name -eq "Network adapter 2" } ) -PortGroup $vdPortGroup2 -Confirm:$False


## start the first VM
Start-VM -VM $VMclone1 -Confirm:$false -RunAsync

## disconnect for Vmware Vcentre

disconnect-viserver -server $vcenter_server -Confirm:$false


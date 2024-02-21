# MicroAppForCX10KTesting
The deployment process for the microservices app for testing the CX10K.

1. Download the OVA file from dropbox, and deploy onto the VMware host or template folder called "Micro".
<br>
2. once on the ESXi host, edit the contents of the build_PS_script.txt to update you local variables.

```
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
```

3. maunally run the script via powershell - As local admin to deploy the images on the hypervisor. 
``` 
Install-Module -Name Vmware.PowerCLI 

```
<br>

4. Deployment script will start the first VM image "k8-master". (you should only have one started at a time until you have completed the Mastersetup of the node)

5. On each node when started (one at a time), login with the user elk/docker and run the Mastersetup.sh
  - the script will give each machine a unique secondary IP, and MachineID.
  - setup the relative components of Kubenetes for the fuction, and deploy the image.
  - provide the output commands for the CX switch routing.


### the script and ova are provided as a demo, and not security considerations have been made.
### this is purely to show and generate traffic via the CX10K so it can be tracked and managed.



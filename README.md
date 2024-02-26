# MicroAppForCX10KTesting
The deployment process for the microservices app for testing the CX10K.

1. Download the OVA file from dropbox, and deploy onto the VMware host or template folder called "Micro".
<br>

2. Download the PS script to help the deployment 
  - edit the contents of the build_PS_script.ps1 to update you local variables.

```
##Variables to be edited ##

$vcenter_server ="192.168.102.102"

$vcenter_user ="administrator@vsphere.local"

$vcenter_pwd =""

$Hostesxi = "192.168.102.103"

$VMsource = "Micro"

$ResPool = "Demo"

$DataStore = "Gen9500gbSSD"

$VmDS = 'Home_Networks'
$VmInt1 = 'H102'
$VmInt2 = 'H101'
```

  

3. maunally run the script via powershell - As local admin to deploy the images on the hypervisor. 
 - run the script from you local admin PS terminal.
``` 
Install-Module -Name Vmware.PowerCLI 
build_PS_script.ps1

```
<br>

4. Deployment script will start the first VM image "k8-master". (you should only have one started at a time until you have completed the Mastersetup of the node)

5. On each node when started (one at a time), login with the user elk/docker and run the setup.sh
```
sudo setup.sh
```

  - the script will give each machine a unique secondary IP, and MachineID.
  - setup the relative components of Kubenetes for the fuction, and deploy the image.
  - provide the output commands for the CX switch routing.
  - Run all the machines throught the host setup first.
  - Then the deploy


### the script and ova are provided as a demo, and not security considerations have been made.
### this is purely to show and generate traffic via the CX10K so it can be tracked and managed.



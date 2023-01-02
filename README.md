# Full Demolab Deployment for Citrix CVAD.
Install a full Citrix-Education-Environment for Tests etc. The the environment is completely independent, with its own network behind a router.

## What it does

Deploys the following:
 - 1 vCenter on ESXi
 - 1 Linux NAT/Router
 - 1 Domaincontroller
 - 1 Fileserver and License Server
 - 2 DDC Controllers with Director
 - 2 Storefront Servers (Cluster)
 - 1 SQL
 - 1 Stand alone Server VDA
 - 1 Stand alone Client VDA

### vCenter
 - installs a standalone vCenter on a standalone ESXi host_folder
 - no Cluster

### Linux NAT/Router
 - installs a ubuntu2004 Server
 - install an configure a DHCP Server
 - configure NAT for internal Network
 - install ansible
 - execute ansible to configure internal lab

### Domaincontroller
 - install a Domaincontroller
 - install a internal CA
 - install a DNS-Server
 - create some Groups
 - create some user
 - create initial GPO's

### FileServer
 - install a Microsoft Fileserver
 - create some Fileshares with Permissions
 - install license server
 - Copies Citrix license files

### DDC
 - Installs components including director
 - Creates Citrix site
 - Creates 2 Machine Catalogs
 - Creates 2 Delivery Groups
 - Creates 2 Published Desktop
 - Creates 3 Applications
    - Notepad
    - Calculator
    - Paint
 - Configures director
    - Adds logon domain
    - Sets default page
    - Removes SSL Warning

### Storefront
 - Installs Storefront components
 - Creates Storefront cluster
 - Configures Storefront
   - Sets default page
   - Enables HTTP loopback for SSL offload
   - Adjusts logoff behavior

### SQL
 - Installs SQL
 - Installs SQL management tools
 - Configures SQL for admins and service account


### VDA
 - Installs VDA components
 - Configures for DDCs

## Serverlist

![overview](/screenshots/overview.png)

|Virtual Machine Name|IP Address|OS|Description|
|:---------------------|:-------------|:------------|:-------------------------------------------|			
|ms-ads-001|            192.168.10.11|Server 2022|Domain Controller, DNS|
|ms-adc-001|            192.168.10.100	|FreeBSD	        |Citrix ADC
|ms-fsr-001|	        192.168.10.17	|Server 2022	    |File Server, Print Server
|ms-sql-001|	        192.168.10.21	|Server 2022	    |SQL Server
|ms-srv-001|	        DHCP	        |Server 2019	    |Server OS VDA - Manually Provisioned
|ms-srv-mst|	        DHCP	        |Server 2019	    |Server OS VDA Master
|ms-stf-002|	        192.168.10.32	|Server 2022	    |Storefront
|ms-stf-001|	        192.168.10.31	|Server 2022	    |Storefront
|ms-vdc-001|	        192.168.10.46	|Server 2022	    |Delivery Controller
|ms-vdc-002|	        192.168.10.47	|Server 2022	    |Delivery Controller
|ms-wrk-001|	        192.168.10.56	|Windows 11	        |Managed Endpoint
|jumphost  |            192.168.10.20  |Windows 11         |Studentdesktop
|natgw     |            192.168.10.254 |Ubuntu 2004        |Gateway, DHCP,


## Prerequisites
- Need VMWare vCenter ISO. https://customerconnect.vmware.com/de/downloads/info/slug/datacenter_cloud_infrastructure/vmware_vsphere/7_0
- Need some Windows Server an Client ISOS. Eval Isos can found here: https://www.microsoft.com/de-de/evalcenter/
- Need CVAD ISO contents copied to accessible share via Ansible account (eg \\\mynas\isos\Citrix\Citrix_Virtual_Apps_and_Desktops_7_1906_2)
    - I used CVAD 1906 2 ISO
- Need SQL ISO contents copied to accessible share via Ansible account (eg \\\mynas\isos\Microsoft\SQL\en_sql_server_2017_standard_x64_dvd_11294407)
    - I used SQL 2017 but other versions should work
- DHCP enabled network
- vCenter access and rights capable of deploying machines
- (optional for remote state) [Terraform Cloud](https://app.terraform.io/signup/account) account created and API key for remote state.



### install Deploymentmachine

- Install Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
    - LINUX-Install
    - sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    - curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    - sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    - sudo apt-get update && sudo apt-get install terraform

- Install Packer (https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
    - LINUX-Install
    - sudo apt-get update && sudo apt-get install packer

- Install Ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
    - LINUX-Install
    - sudo apt update
    - sudo apt install software-properties-common
    - sudo add-apt-repository --yes --update ppa:ansible/ansible
    - sudo apt install ansible
    - sudo apt install python3-argcomplete
    - sudo activate-global-python-argcomplete3
    - sudo apt install python3-pip
    - pip3 install PyVmomi
    - ansible-galaxy collection install community.vmware
    - for some futher things to do with PowerCLI or Powershell, ive installed PowerShell and PowerCLI
        - sudo apt-get install -y wget apt-transport-https software-properties-common
        - wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
        - sudo dpkg -i packages-microsoft-prod.deb
        - sudo apt-get update
        - sudo apt-get install -y powershell
        - Start PowerShell with sudo pwsh   
         - sudo pwsh
         - Install-Module vmware.powercli
         - Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers
         - Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
         - exit

- This REPO cloned down

### deploy vCenter

1. prepare vCenter.iso
    extract the iso-file
    go to the folder vcsa and copy the VMware-vCenter-Server-Appliance-7.xxxxx_OVF10.ova file to /ansible/roles/vCenter/sources (create a new folder, sources is declared in gitnore.)
    adjust the main.tf in /ansible/roles/vCenter/defaults line 17
2. From the *ansible/roles/vCenter/defaults directory copy **main.example** to **main.yml**
3. Adjust variables to reflect environment
4. run the playbook: 
    ansible-playbook -i inventory.yml deploy-vcenter.yml
    or with ask-pass option:
    ansible-playbook -i inventory.yml deploy-vcenter.yml --ask-pass

### vCenter Windows Server Template

## Packer
Packer setup consists of xxx main components:
* `windows-server-2016.json`
* `vars.json`
* `setup` dir containing files necessary for automatic Windows installation
* `ubuntu2004.json`
    
1. I used Windows Server 2019 but I assume 2016 should also work.
2. WinRM needs to be configured and **CredSSP** enabled
    - Ansible provides a great script to enable quickly https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1
    - Run manually `Enable-WSManCredSSP -Role Server -Force`
3. I use linked clones to quickly deploy.  In order for this to work the template needs to be converted to a VM with a **single snapshot** created.

## Getting Started

### Terraform
1. From the *terraform* directory copy **lab.tfvars.sample** to **lab.tfvars**
2. Adjust variables to reflect vCenter environment
3. Review **main.tf** and adjust any VM resources if needed
4. (If using remote cloud state) At the bottom of **main.tf** uncomment the *terraform* section and edit the *organization* and *workspaces* fields
```
terraform {
   backend "remote" {
     organization = "TechDrabble"
     workspaces {
       name = "cvad-lab"
     }
   }
}
```
5. run `terraform init` to install needed provider

### Ansible
1. From the *ansible* directory copy **vars.yml.sample** to **vars.yml**
2. Adjust variables to reflect environment
3. If you want to license CVAD environment place generated license file in **ansible\roles\license\files**

## Deploy
If you are comfortable with below process `build.sh` handles the below steps.  

**Note:** If you prefer to run many of the tasks asynchronously switch the `ansible-playbook` lines within `build.sh` which will call a seperate playbook. This is faster but can consume more resources and less informative output.
```
#Sync
#ansible-playbook --inventory-file=/usr/bin/terraform-inventory ./ansible/playbook.yml -e @./ansible/vars.yml
#If you prefer to run most of the tasks async (can increase resources)
ansible-playbook --inventory-file=/usr/bin/terraform-inventory ./ansible/playbook-async.yml -e @./ansible/vars.yml
```

## Terraform
1. From the *terraform* directory run `terraform apply --var-file="lab.tfvars"`
2. Verify the results and type `yes` to start the build

## Ansible
1. From the *root* directory and the terraform deployment is completed run the following
    - `export TF_STATE=./terraform` used for the inventory script
    - Synchronous run (Serial tasks)
        - `ansible-playbook --inventory-file=/usr/bin/terraform-inventory ./ansible/playbook.yml -e @./ansible/vars.yml` to start the playbook
    - Asynchronous run (Parallel tasks)
        - `ansible-playbook --inventory-file=/usr/bin/terraform-inventory ./ansible/playbook-async.yml -e @./ansible/vars.yml` to start the playbook
    - Grab coffee

## Destroy
If you are comfortable with below process `destroy.sh` handles the below steps.  **Please note this does not clean up the computer accounts**

## Terraform
1. From the *terraform* directory run `terraform destroy --var-file="lab.tfvars"`
2. Verify the results and type `yes` to destroy



# Citrix Virtual Apps and Desktop vCenter Lab Deploy
Uses Terraform and Ansible to deploy a fully functional CVAD environment. Many of the scripts used are thanks to [Dennis Span](https://dennisspan.com) and his fantastic blog.



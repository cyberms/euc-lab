##################################################################################
# VARIABLES
##################################################################################


# Credentials Virtual Machine

config_pass                     = "windows"
config_user                     = "windows"


# Virtual Machine Settings

vm_guest_os_family              = "windows"
vm_guest_os_vendor              = "microsoft"
vm_guest_os_member              = "client"
vm_guest_os_version             = "2111"
#vm_guest_os_type                = "windows9Server64Guest"

# Config Virtual Machine

cpus                            = "4"
disk_controller_type            = ["lsilogic-sas"]
disk_size                       = "65536" #65536 min requirements for Win11
disk_thin_provisioned           = "true"
memory                          = "4096"
memory_reserve_all              = "true"
firmaware                       = "efi-secure" #or bios

#vm_version                      = 14

# Config VM Removable Disks

iso_datastore                   = "nvme-datastore"
iso_path                        = "isos"
iso_file                        = "22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_checksum_type               = "SHA256"
iso_checksum                    = "ebbc79106715f44f5020f77bd90721b17c5a877cbc15a3535b99155493a1bb3f"

# Config VM Network

network                         = "external"
network_card                    = "vmxnet3"

# Remote Config

winadmin-password               = "Password1"
restart_timeout                 = "5m"
winrm_timeout                   = "10h"
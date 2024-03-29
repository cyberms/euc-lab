##################################################################################
# VARIABLES
##################################################################################


# Credentials Virtual Machine

config_pass                     = "windows"
config_user                     = "windows"


# Virtual Machine Settings

vm_guest_os_family              = "windows"
vm_guest_os_vendor              = "microsoft"
vm_guest_os_member              = "server"
vm_guest_os_version             = "2022"
#vm_guest_os_type                = "windows9Server64Guest"

# Config Virtual Machine

#template_name                   = "Windows-Server_2019"
cpus                            = "4"
disk_controller_type            = ["lsilogic-sas"]
disk_size                       = "40960"
disk_thin_provisioned           = "true"
memory                          = "8192"
memory_reserve_all              = "true"
#vm_version                      = 14

# Config VM Removable Disks

iso_datastore                   = "nvme-datastore"
iso_path                        = "isos"
iso_file                        = "SERVER_EVAL_x64FRE_en-us.iso"
iso_checksum_type               = "SHA256"
iso_checksum                    = "3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"

# Config VM Network

network                         = "external"
network_card                    = "vmxnet3"

# Remote Config

winadmin-password               = "Password1"
restart_timeout                 = "5m"
winrm_timeout                   = "10h"
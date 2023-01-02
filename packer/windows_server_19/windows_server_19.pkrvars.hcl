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
vm_guest_os_version             = "2019"
#vm_guest_os_type                = "windows9Server64Guest"

# Config Virtual Machine

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
iso_file                        = "17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
iso_checksum_type               = "SHA256"
iso_checksum                    = "549bca46c055157291be6c22a3aaaed8330e78ef4382c99ee82c896426a1cee1"

# Config VM Network

network                         = "external"
network_card                    = "vmxnet3"

# Remote Config

winadmin-password               = "Password1"
restart_timeout                 = "5m"
winrm_timeout                   = "10h"
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
disk_size                       = "40960"
disk_thin_provisioned           = "true"
memory                          = "4096"
memory_reserve_all              = "true"
#vm_version                      = 14

# Config VM Removable Disks

iso_datastore                   = "nvme-datastore"
iso_path                        = "isos"
iso_file                        = "22000.318.211104-1236.co_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_checksum_type               = "SHA256"
iso_checksum                    = "684bc16adbd792ef2f7810158a3f387f23bf95e1aee5f16270c5b7f56db753b6"

# Config VM Network

network                         = "external"
network_card                    = "vmxnet3"

# Remote Config

winadmin-password               = "Password1"
restart_timeout                 = "5m"
winrm_timeout                   = "10h"
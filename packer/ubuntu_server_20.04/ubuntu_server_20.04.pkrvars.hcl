##################################################################################
# VARIABLES
##################################################################################

# HTTP Settings

http_directory              = "http"

#Credentials Virtual Machine

ssh_username                = "ubuntu"
ssh_password                = "ubuntu"

# Virtual Machine Settings

vm_guest_os_family          = "linux"
vm_guest_os_vendor          = "ubuntu"
vm_guest_os_member          = "server"
vm_guest_os_version         = "20-04-lts"
vm_guest_os_type            = "ubuntu64Guest"

# Config virtual Machine

vm_version                  = 14
vm_firmware                 = "bios"
vm_cdrom_type               = "sata"
vm_cpu_sockets              = 4
vm_cpu_cores                = 1
vm_mem_size                 = 8192
vm_disk_size                = 20480
vm_disk_thin_provisioned    = true
vm_disk_controller_type     = ["pvscsi"]
vm_boot_wait                = "5s"

#Config VM Network

vm_network_card             = "vmxnet3"
vcenter_network             = "external"

# Config removable Disks

iso_file                    = "ubuntu-20.04.3-live-server-amd64.iso"
iso_url                     = "http://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"
iso_checksum                = "36f15879bd9dfd061cd588620a164a82972663fdd148cce1f70d57d314c21b73"

# Scripts

shell_scripts               = ["./scripts/setup_ubuntu2004.sh"]

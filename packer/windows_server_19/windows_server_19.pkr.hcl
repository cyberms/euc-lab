##################################################################################
# Variables
##################################################################################

# vcenter credetials

variable "vsphere_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = ""
}

variable "vsphere_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = ""
}

# vSphere Objects

variable "vsphere_insecure_connection" {
  type    = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}

variable "vsphere_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}

variable "vsphere_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
  default = ""
}

variable "vsphere_host" {
  type = string
  description = "The ESXi host where target VM is created."
  default = ""
}

variable "vsphere_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = ""
}

variable "vsphere_folder" {
  type    = string
  description = "The VM folder in which the VM template will be created."
  default = ""
}

# Credentials Virtual Machine

variable "config_pass" {
  type    = string
  description = "The plaintext password for authenticating to vm."
  default = ""
}

variable "config_user" {
  type    = string
  description = "The username for authenticating to vm."
  default = ""
}

# Virtual Machine Settings

variable "vm_guest_os_vendor" {
  type        = string
  description = "The guest operating system vendor. Used for naming . (e.g. 'microsoft)"
}

variable "vm_guest_os_family" {
  type        = string
  description = "The guest operating system family. Used for naming and VMware tools. (e.g.'windows')"
}

variable "vm_guest_os_member" {
  type        = string
  description = "The guest operating system member. Used for naming. (e.g. 'server')"
}

variable "vm_guest_os_version" {
  type        = string
  description = "The guest operating system version. Used for naming. (e.g. '2022')"
}

# config virtual Machine

# variable "template_name" {
#   type    = string
#   description = "The virtual machine name"
#   default = ""
# }

variable "cpus" {
  type = number
  description = "The number of virtual CPUs sockets."
}

variable "disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
}

variable "disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
}

variable "disk_thin_provisioned" {
  type = string
  description = "vm disk provioning method"
  default = "true"
}

variable "memory" {
  type = number
  description = "The size for the virtual memory in MB."
}

variable "memory_reserve_all" {
  type = string
  description = "all memory reserved for vm"
  default = "true"
}

# Config VM Removable Disks

variable "iso_datastore" {
    type        = string
    description = "vSphere datastore name where source OS media reside"
}

variable "iso_path" {
  type    = string
  description = "The path on the source vSphere datastore for ISO images."
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  description = "The path on the source vSphere datastore for ISO images."
  default = ""
}

variable "iso_checksum_type" {
  type    = string
  description = "The SHA checkcum of the ISO image."
  default = ""
}

variable "iso_checksum" {
  type    = string
  description = "The SHA checkcum of the ISO image."
  default = ""
}

variable "iso_file" {
  type    = string
  description = "The OS ISO image."
  default = ""
}

# config vm network

variable "network" {
  type = string
  description = "The virtual network."
  default = ""
}

variable "network_card" {
  type = string
  description = "The virtual network card type."
  default = ""
}

variable "winadmin-password" {
  type = string
  description = "winadmin password. "
  default = ""
}

variable "restart_timeout" {
  type = string
  description = "restart timeout."
  default = ""
}

variable "winrm_timeout" {
  type = string
  description = "winrm timeout."
  default = ""
}

##################################################################################
# Requirements
##################################################################################

packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
    }
  }
}


##################################################################################
# SOURCE
##################################################################################

source "vsphere-iso" "windows_server_19" {
  # vcenter settings
  vcenter_server          = "${var.vsphere_server}"
  username                = "${var.vsphere_username}"
  password                = "${var.vsphere_password}"
  datacenter              = "${var.vsphere_datacenter}"
  datastore               = "${var.vsphere_datastore}"
  host                    = "${var.vsphere_host}"
  folder                  = "${var.vsphere_folder}"
  insecure_connection     = "${var.vsphere_insecure_connection}"
  # config virtual machine
  vm_name              = "${var.vm_guest_os_family}-${var.vm_guest_os_member}-${var.vm_guest_os_version}"
  firmware                = "bios"
  CPUs                    = "${var.cpus}"
  cpu_cores               = 4
  RAM                     = "${var.memory}"
  RAM_reserve_all         = "${var.memory_reserve_all}"
  guest_os_type           = "windows9Server64Guest"
  disk_controller_type    = "${var.disk_controller_type}"
  storage {
    disk_size             = "${var.disk_size}"
    disk_thin_provisioned = "${var.disk_thin_provisioned}"
  }

  floppy_files            = [           
        "./http/autounattend.xml",
        "./scripts/disable-network-discovery.cmd",
        "./scripts/enable-rdp.cmd",
        "./scripts/enable-winrm.ps1",
        "./scripts/install-vm-tools.cmd",
        "./scripts/set-temp.ps1",
        "./scripts/setup-winrm.ps1",
        "./scripts/sysprep.bat",
       # "./scripts/unattend.xml"
  ]

  iso_paths               = [
    "[${ var.iso_datastore }] ${ var.iso_path }/${ var.iso_file }",
    "[] /vmimages/tools-isoimages/${var.vm_guest_os_family}.iso"
    ]

  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum}"

  network_adapters {
    network               = "${var.network}"
    network_card          = "${var.network_card}"
  }
  convert_to_template     = true

  # boot / shutdown settings
  boot_wait               = "10s"
  communicator            = "winrm"
  winrm_insecure          = true
  winrm_password          = "${var.winadmin-password}"
  winrm_use_ssl           = true
  winrm_username          = "Administrator"
  
  shutdown_command        = "A:/sysprep.bat"
  shutdown_timeout        = "3h"
  
  
  
  

}

##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.vsphere-iso.windows_server_19"]

  provisioner "windows-shell" {
    inline = ["ipconfig"]
  }

  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'",
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Defender*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }

}

resource "proxmox_vm_qemu" "nfs" {
  name                   = "nfs"
  target_node            = "pve"
  memory                 = 2048
  cores                  = 2
  agent                  = 1
  force_create           = false
  tablet                 = false
  onboot                 = true
  define_connection_info = true
  kvm                    = true
  bios                   = "ovmf"
  cpu                    = "host"
  machine                = "q35"
  os_type                = "cloud-init"
  scsihw                 = "virtio-scsi-single"
  hotplug                = "disk,network,usb"
  boot                   = "order=scsi0;net0"
  clone                  = "packer-almalinux"

  disks {
    scsi {
      scsi0 {
        disk {
          cache    = "none"
          iothread = true
          size     = 500
          storage  = "local-lvm"
        }
      }
    }
  }

  network {
    bridge   = "misc"
    model    = "virtio"
    firewall = true
  }

  # Cloud Init
  cloudinit_cdrom_storage = "local-lvm"
  ipconfig0               = "ip=192.168.60.230/24,gw=192.168.60.1"
  nameserver              = "192.168.60.1"
  ciuser                  = "serveradmin"
  sshkeys                 = var.publick_ssh_key
}

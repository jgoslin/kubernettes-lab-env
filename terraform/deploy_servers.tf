#
# Proxmox Full-Clone
# ---

variable "servers" {
  description = "list of servers to deploy"
  type = list(map(any))
  default = [
    {
      target = "pve1"
      name = "k3s-ctrl1"
      desc = "k3s master node"
      vmid = 8001
      ip   = "192.168.136.231/24"
      virtio = "D6:BE:82:D5:FB:01"
      cores = 2
      memory = 2048
    },
    {
      target = "pve2"
      name = "k3s-ctrl2"
      desc = "k3s master node"
      vmid = 8002
      ip   = "192.168.136.232/24"
      virtio = "D6:BE:82:D5:FB:02"
      cores = 2
      memory = 2048
    },
    {
      target  = "pve1"
      name = "k3s-ctrl3"
      desc = "k3s master node"
      vmid = 8003
      ip   = "192.168.136.233/24"
      virtio = "D6:BE:82:D5:FB:03"
      cores = 2
      memory = 2048
    },
    {
      target = "pve2"
      name = "k3s-node1"
      desc = "k3s worker node"
      vmid = 8010
      ip   = "192.168.136.234/24"
      virtio = "D6:BE:82:D5:FB:04"
      cores = 4
      memory = 4096
    },
    {
      target = "pve1"
      name = "k3s-node2"
      desc = "k3s worker node"
      vmid = 8011
      ip   = "192.168.136.235/24"
      virtio = "D6:BE:82:D5:FB:05"
      cores = 4
      memory = 4096
    },
    {
      target = "pve2"
      name = "k3s-node3"
      desc = "k3s worker node"
      vmid = 8012
      ip   = "192.168.136.236/24"
      virtio = "D6:BE:82:D5:FB:06"
      cores = 4
      memory = 4096
    },
    {
      target = "pve1"
      name = "k3s-store1"
      desc = "k3s worker node"
      vmid = 8101
      ip   = "192.168.136.237/24"
      virtio = "D6:BE:82:D5:FB:07"
      cores = 4
      memory = 4096
    },
    {
      target = "pve2"
      name = "k3s-store2"
      desc = "k3s worker node"
      vmid = 8102
      ip   = "192.168.136.238/24"
      virtio = "D6:BE:82:D5:FB:08"
      cores = 4
      memory = 4096
    },
  ]
}

resource "proxmox_vm_qemu" "servers" {
    for_each = { for server in var.servers : server.name => server }
    
        # Proxmox Host Items
        clone = "ubuntu-s-2204"
        target_node = each.value.target

        # VM General Settings
        vmid = each.value.vmid
        name = each.value.name
        desc = each.value.desc
        os_type = "cloud-init"   
        cpu = "host"
        agent = 1
        onboot = true

        # VM System Resource Settings
        sockets = 1
        cores = each.value.cores
        memory = each.value.memory

        # VM Network Settings
        network {
          bridge = "vmbr0"
          macaddr = each.value.virtio
          model  = "virtio"
        }
        
        ipconfig0 = "gw=192.168.136.1,ip=${each.value.ip}"
        searchdomain = "home.goslin.us"
        nameserver = "192.168.136.1"

        # VM Disk Settings  
        disk {
          storage = "truenas-nfs"
          size = "32G"
          type = "scsi"
          ssd = 1
          discard = "on"
          iothread = 1
        }

        #VM Display Settings
        vga {
            type = "serial0"
        }
}

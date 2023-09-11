#
# Proxmox Full-Clone
# ---

variable "servers" {
  description = "list of servers to deploy"
  type = list(map(any))
  default = [
    {
      target = "pve1"
      name = "k3s-master1"
      desc = "k3s master node"
      vmid = 8001
      ip   = "192.168.163.230/24"
      cores = 2
      memory = 2048
    },
    {
      target = "pve2"
      name = "k3s-master2"
      desc = "k3s master node"
      vmid = 8002
      ip   = "192.168.163.231/24"
      cores = 2
      memory = 2048
    },
    {
      target = "pve1"
      name = "k3s-master3"
      desc = "k3s master node"
      vmid = 8003
      ip   = "192.168.163.232/24"
      cores = 2
      memory = 2048
    },
    {
      target = "pve2"
      name = "k3s-worker1"
      desc = "k3s worker node"
      vmid = 8010
      ip   = "192.168.163.233/24"
      cores = 4
      memory = 4096
    },
    {
      target = "pve1"
      name = "k3s-worker2"
      desc = "k3s worker node"
      vmid = 8011
      ip   = "192.168.163.234/24"
      cores = 4
      memory = 4096
    },
    {
      target = "pve2"
      name = "k3s-worker3"
      desc = "k3s worker node"
      vmid = 8012
      ip   = "192.168.163.235/24"
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

        # VM System Resource Settings
        sockets = 1
        cores = each.value.cores
        memory = 2048

        # VM Network Settings
        network {
            bridge = "vmbr0"
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

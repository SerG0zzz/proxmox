locals {
  nodes = {
    "node-01" = { 
      vm_id     = 151, 
      ip_main   = "192.168.0.151",
      ip_second = "192.168.1.151"
    }
    "node-02" = {
      vm_id     = 152,
      ip_main   = "192.168.0.152",
      ip_second = "192.168.1.152"
    }
    "node-03" = {
      vm_id     = 153,
      ip_main   = "192.168.0.153",
      ip_second = "192.168.1.153"
    }
  }
}

resource "proxmox_virtual_environment_vm" "bitrix_nodes" {
  for_each = local.nodes

  name      = each.key
  node_name = "pve"
  vm_id     = each.value.vm_id

  clone {
    vm_id   = 112
    retries = 5
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "HDD-2"
    interface    = "sata0"
    size         = 100
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  network_device {
    bridge = "vmbr99"
    model  = "virtio" 
  }

  initialization {
    type = "nocloud"

    ip_config {
      ipv4 {
        address = "${each.value.ip_main}/24"
        gateway = "192.168.0.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }

    user_account {
      username = "root"
      password = "qwerty"
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3BZ+RU1lOiXGxScTuwf8askuAOA8184GMk23Lpvdon root@IaC"
      ]
    }
  }

  agent {
    enabled = true
    type    = "virtio"
  }

  timeout_clone  = 1800
  timeout_create = 900

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = each.value.ip_main  # 192.168.0.151 и т.д.
      user     = "root"
      #password = "qwerty"
      private_key = file("~/.ssh/id_ed25519")
      timeout  = "10m"
      #host_key = "${sha256("dummy")}"
    }

    inline = [
      # 1. Переименовываем интерфейс (без перезагрузки)
      "echo 'Немедленное переименование enp6s19 в eth1...'",
      "ip link set enp6s19 down",
      "ip link set enp6s19 name eth1",
      "ip link set eth1 up",
      # 2. Создаем постоянное правило для перезагрузок
      "echo 'Создание udev правила...'",
      "MAC=$(ip link show eth1 | grep link/ether | awk '{print $2}')",
      "cat > /etc/udev/rules.d/70-persistent-net.rules << EOF",
      "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$MAC\", NAME=\"eth1\"",
      "EOF",
      # 3. Применяем udev правило
      "udevadm control --reload-rules",
      "udevadm trigger",
      # 4. Настраиваем NetworkManager ДЛЯ eth1
      "echo 'Настройка NetworkManager для eth1...'",
      "nmcli connection delete enp6s19 2>/dev/null || true",
      "nmcli connection delete eth1 2>/dev/null || true",
      "nmcli connection add type ethernet con-name eth1 ifname eth1",
      "nmcli connection modify eth1 ipv4.method manual ipv4.addresses ${each.value.ip_second}/24",
      "nmcli connection up eth1",
      # 5. Проверяем
      "echo '✅ Проверка:'",
      "ip link show | grep -E '^(2:|3:)'",
      "ip -4 addr show eth1",
      "echo 'Готово: ${each.value.ip_second} на eth1'"
    ]
  }
}

# Output для for_each
output "vm_info" {
  value = <<-EOT
  Созданы ВМ:
  %{ for name, config in local.nodes }
  - ${name} (ID: ${config.vm_id}) → ${config.ip_main} and ${config.ip_second} 
  %{ endfor }

  Проверка:
  %{ for name, config in local.nodes }
  ssh root@${config.ip_main}
  %{ endfor }
  EOT
}

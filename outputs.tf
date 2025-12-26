output "created_vms" {
  description = "Созданные виртуальные машины"
  value = [
    for name, vm in proxmox_virtual_environment_vm.bitrix_nodes : {
      name      = vm.name
      id        = vm.vm_id
      ip        = local.nodes[name].ip_main
      hostname  = name
      status    = "Создана"
    }
  ]
}

output "ssh_connection_commands" {
  description = "Команды для подключения по SSH"
  value = [
    for name, vm in proxmox_virtual_environment_vm.bitrix_nodes : 
    "ssh root@${local.nodes[name].ip_main} # ${vm.name}"
  ]
}

output "proxmox_console_urls" {
  description = "Ссылки на консоль в Proxmox"
  value = [
    for name, vm in proxmox_virtual_environment_vm.bitrix_nodes : 
    "https://proxmox.serg0.ru/#v1:0:=qemu%2F${vm.vm_id}:"
  ]
}

output "summary" {
  description = "Сводка по развертыванию"
  value = <<-EOT
  
  ✅ РАЗВЕРТЫВАНИЕ ЗАВЕРШЕНО
  
  Создано ${length(proxmox_virtual_environment_vm.bitrix_nodes)} нод Bitrix:
  ${join("\n", [for name, vm in proxmox_virtual_environment_vm.bitrix_nodes : 
    "  • ${vm.name} (ID: ${vm.vm_id}) → ${local.nodes[name].ip_main}"
  ])}
  
  Для подключения:
  ${join("\n", [for name, vm in proxmox_virtual_environment_vm.bitrix_nodes : 
    "  ssh root@${local.nodes[name].ip_main}"
  ])}
  
  Проверь сеть:
  ${join("\n", [for name, vm in proxmox_virtual_environment_vm.bitrix_nodes : 
    "  ping -c 2 ${local.nodes[name].ip_main}"
  ])}
  
  EOT
}

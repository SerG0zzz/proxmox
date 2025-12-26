# Основные параметры Proxmox
variable "proxmox_host" {
  description = "IP-адрес или доменное имя сервера Proxmox"
  type        = string
  default     = "proxmox.serg0.ru"
}

variable "proxmox_node" {
  description = "Имя узла Proxmox, где будут создаваться ВМ"
  type        = string
  default     = "proxmox.serg0.ru"
}

variable "vm_template_name" {
  description = "Имя готового шаблона ВМ в Proxmox для клонирования"
  type        = string
  default     = "bitrix-template"
}

# Секретные данные (значения будут в terraform.tfvars или env переменных)
variable "pm_api_token_id" {
  description = "ID API-токена в формате 'USER@REALM!TOKEN_NAME'"
  type        = string
  sensitive   = true
}

variable "pm_api_token_secret" {
  description = "Секретная часть API-токена"
  type        = string
  sensitive   = true
}

# Параметры виртуальных машин
variable "vm_cores" {
  description = "Количество ядер CPU на ВМ"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Объем RAM (в МБ) на ВМ"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Размер системного диска"
  type        = string
  default     = "100G"
}

variable "vm_storage" {
  description = "Имя хранилища Proxmox для диска"
  type        = string
  default     = "local-lvm"
}

variable "vm_network_bridge" {
  description = "Имя сетевого моста Proxmox"
  type        = string
  default     = "vmbr0"
}

# Настройки Cloud-Init
variable "vm_ciuser" {
  description = "Имя пользователя для Cloud-Init"
  type        = string
  default     = "ubuntu"
}

variable "vm_cipassword" {
  description = "Пароль пользователя (можно оставить пустым, если используете SSH-ключи)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "vm_ssh_keys" {
  description = "Содержимое публичного SSH-ключа для доступа"
  type        = string
  sensitive   = true
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3BZ+RU1lOiXGxScTuwf8askuAOA8184GMk23Lpvdon root@IaC"
}

# Настройки сети
variable "vm_ipconfig_base" {
  description = "Базовый IP-адрес и маска для нод (например, '192.168.0.150/24,gw=192.168.0.1')"
  type        = string
  default     = "192.168.0.150/24,gw=192.168.0.1"
}

variable "vm_dns_servers" {
  description = "DNS-серверы через запятую"
  type        = string
  default     = "8.8.8.8,1.1.1.1"
}

variable "vm_template_id" {
  description = "ID шаблона VM в Proxmox"
  type        = number
  default     = 112
}

variable "ssh_public_key" {
  description = "Публичный SSH ключ для доступа к ВМ"
  type        = string
  sensitive   = true
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3BZ+RU1lOiXGxScTuwf8askuAOA8184GMk23Lpvdon root@IaC"
}

variable "vm_base_ip" {
  description = "Базовый IP адрес для ВМ (например: 192.168.0)"
  type        = string
  default     = "192.168.0"
}

variable "template_id" {
  description = "ID шаблона в Proxmox"
  type        = number
  default     = 112
}

variable "gateway" {
  description = "Шлюз по умолчанию"
  type        = string
  default     = "192.168.0.1"
}

variable "dns_servers" {
  description = "DNS серверы"
  type        = list(string)
  default     = ["8.8.8.8", "1.1.1.1"]
}

# Настройки для всех нод
variable "vm_settings" {
  type = object({
    count      = number
    start_ip   = number
    cores      = number
    memory_mb  = number
    disk_size  = number
    datastore  = string
  })
  default = {
    count     = 3      # Количество нод
    start_ip  = 151    # Первый IP (151, 152, 153)
    cores     = 2      # Ядра на ноду
    memory_mb = 4096   # Память в МБ
    disk_size = 100    # Диск в ГБ
    datastore = "HDD-2" # Хранилище
  }
}

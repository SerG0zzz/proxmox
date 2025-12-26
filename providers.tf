terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.89.1" # Актуальная версия на момент написания
    }
  }
}

provider "proxmox" {
  endpoint = "https://proxmox.serg0.ru/"
  api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"
  insecure = true
  # Опционально: настройка SSH для Cloud-Init
  #ssh {
  #  username = "root"
  #  private_key = file("~/.ssh/id_ed25519") # Если используете ключ
  #}
}

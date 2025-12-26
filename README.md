# proxmox
Пример разворачивания 3 ВМ из шаблона с помощью провайдера для Проксмокс в терраформ.

Для работы терраформ нужно прописать 2 переменных в terraform.tfvars:
 - pm_api_token_id ид токена
 - pm_api_token_secret секрет
И выдать нужные права для токена в Проксмокс

Для инициализации: terraform init и terraform plan:
<img width="579" height="524" alt="image" src="https://github.com/user-attachments/assets/01e5c842-8515-486c-8108-d64b4d2ff4fe" />

Для выполненеия: terraform apply
<img width="502" height="607" alt="image" src="https://github.com/user-attachments/assets/a9a8fae9-d0f5-462b-845f-64b3edc664be" />

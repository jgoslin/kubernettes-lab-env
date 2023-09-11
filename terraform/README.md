# terraform-proxmox-clone

This project clones a proxmox template using terraform

The proxmox.audo.tfvars file is omitted for security reasons

    Create the file manually and add the following parameters
      proxmox_api_url = "https://yourserver:8006/api2/json"
      proxmox_api_token_id ="your_token_id"
      proxmox_api_token_secret ="your_secret"
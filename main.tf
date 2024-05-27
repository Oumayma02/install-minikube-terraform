terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://192.168.254.153:8006/api2/json"
  pm_api_token_id     = "terraform@pam!terraform"
  pm_api_token_secret = "c467d123-6860-4936-9c17-66fdb00ae41a"
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "test_server" {
  count = 1

  name        = var.vm_name
  target_node = var.proxmox_host
  clone       = var.template_name
  os_type     = "cloud-init"
  cores       = var.vm_cores
  sockets     = 1
  cpu         = "host"
  memory      = var.vm_memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    size    = var.disk_size
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.ip
      private_key = file(var.ssh_key)
      port        = 22
    }
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn",
      "echo 'Checking for any apt locks...'",
      "while sudo lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || sudo lsof /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 15; done",
      "echo 'Updating package lists...'",
      "sudo apt-get update -y",
      "echo 'Installing prerequisites for Docker...'",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "echo 'Adding Docker GPG key and repository...'",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "CODENAME=$(lsb_release -cs)",
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $CODENAME stable\" | sudo tee /etc/apt/sources.list.d/docker.list",
      "echo 'Installing Docker...'",
      "sudo apt-get update -y && sudo apt-get install -y docker-ce docker-ce-cli containerd.io || (echo 'Docker installation failed' && exit 1)",
      "sudo systemctl enable docker || echo 'Failed to enable Docker'",
      "sudo systemctl start docker || echo 'Failed to start Docker'",
      "echo 'Installing conntrack and kubectl...'",
      "sudo apt-get install -y conntrack kubectl",
      "echo 'Adding user to the docker group...'",
      "sudo usermod -aG docker $USER",
      "echo 'Downloading Minikube...'",
      "curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "echo 'Installing Minikube...'",
      "sudo install minikube-linux-amd64 /usr/local/bin/minikube",
      "echo 'Minikube installation completed.'",
    ]
  }
}

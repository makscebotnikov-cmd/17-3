### === Task 2 - 1 ===
resource "yandex_compute_instance" "web_count" {
  count       = 2
  name        = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  #metadata = {
  #  ssh-keys = "ubuntu:${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
  #}

  # === Task 2 - 5  
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }

  ### === Task 2 - 4 ===
  depends_on = [
    yandex_compute_instance.db
  ]
}

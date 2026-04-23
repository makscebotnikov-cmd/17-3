# === Task 3 - 1 ===
resource "yandex_compute_disk" "data_disk" {
  count = 3
  name  = "data_disk_${count.index + 1}"
  type  = "network-hdd"
  zone  = var.default_zone
  size  = 1
}

# === Task 3 - 2 ===
resource "yandex_compute_instance" "storage" {
  name        = "storage"
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

  # === Динамическое подключение дисков ===
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.data_disk
    
    content {
      disk_id     = secondary_disk.value.id
      # Если диск нужно оставить после удаления машины
      auto_delete = false
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

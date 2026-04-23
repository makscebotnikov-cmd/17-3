locals {
  db_vms_map = {
    for vm in var.each_vm : vm.vm_name => vm
  }
}

### === Task 2 - 2 ===
resource "yandex_compute_instance" "db" {
  for_each    = local.db_vms_map
  name        = "db-${each.key}"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = "network-hdd"
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  #metadata = {
  #  ssh-keys = "ubuntu:${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
  #}

  # === Task 2 - 5 === 
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

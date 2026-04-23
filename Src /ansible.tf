locals {
  webservers = [
    for instance in yandex_compute_instance.web_count : {
      name   = instance.name
      nat_ip = instance.network_interface.0.nat_ip_address
      fqdn   = instance.fqdn
    }
  ]

  databases = [
    for instance in yandex_compute_instance.db : {
      name   = instance.name
      nat_ip = instance.network_interface.0.nat_ip_address
      fqdn   = instance.fqdn
    }
  ]

  storage = [
    {
      name   = yandex_compute_instance.storage.name
      nat_ip = yandex_compute_instance.storage.network_interface.0.nat_ip_address
      fqdn   = yandex_compute_instance.storage.fqdn
    }
  ]
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = templatefile("${path.module}/inventory.tmpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
}

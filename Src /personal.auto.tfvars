# === Переменные аккаунта ===
token     = ""
cloud_id  = ""
folder_id = ""

# yc compute image list --folder-id standard-images | grep ubuntu-2004-lts
image_id = "fd835npr436ep5g144gq"

### === Task 2 - 2 ===
each_vm = [
  {
    vm_name     = "main"
    cpu         = 2
    ram         = 4
    disk_volume = 20
  },
  {
    vm_name     = "replica"
    cpu         = 2
    ram         = 2
    disk_volume = 10
  }
]

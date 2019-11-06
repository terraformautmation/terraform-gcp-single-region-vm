# Create Google Cloud VM | vm.tf

# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 4
}

# Create VM #1
resource "google_compute_instance" "vm_instance_1" {
  name         = "${var.app_name}-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = var.gcp_zone_1
  hostname     = "${var.app_name}-vm-${random_id.instance_id.hex}.${var.app_domain}"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential apache2"

  network_interface {
    network       = "${var.app_name}-vpc"
    access_config { }
  }
} 

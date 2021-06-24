# Output VM1
output "instance_id_vm1" {
  value = "${google_compute_instance.vm_instance_1.self_link}"
}

output "ip-vm1" {
  value = "${google_compute_instance.vm_instance_1.network_interface.0.access_config.0.nat_ip}"
}

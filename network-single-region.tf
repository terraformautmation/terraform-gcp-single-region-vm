# Single region network configuration | network-single-region.tf
# Define GCP Region
variable "gcp_region_1" {
  type        = string
  description = "GCP region"
}

# Define GCP Zone
variable "gcp_zone_1" {
  type        = string
  description = "GCP zone"
}

# Define Private Subnet
variable "private_subnet_cidr_1" {
  type        = string
  description = "Private subnet CIDR 1"
}

# Define Public Subnet
variable "public_subnet_cidr_1" {
  type        = string
  description = "Public subnet CIDR 1"
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.app_name}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# Create public subnet
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "${var.app_name}-public-subnet-1"
  ip_cidr_range = var.public_subnet_cidr_1
  network       = google_compute_network.vpc.name
  region        = var.gcp_region_1
}

# Create private subnet 
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "${var.app_name}-private-subnet-1"
  ip_cidr_range = var.private_subnet_cidr_1
  network       = google_compute_network.vpc.name
  region        = var.gcp_region_1
}

# Allow internal icmp (disable for better security)
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.app_name}-fw-allow-internal"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = [
      "0-65535",
    ]
  }
  allow {
    protocol = "udp"
    ports = [
      "0-65535",
    ]
  }
  source_ranges = [
    "${var.private_subnet_cidr_1}",
    "${var.public_subnet_cidr_1}",
  ]
}

module "nat-gateway1" {
  source  = "GoogleCloudPlatform/nat-gateway/google"
  version = "1.2.3"
  # The region to create the nat gateway instance in.
  region = ""
}

module "lb-internal1" {
  source  = "GoogleCloudPlatform/lb-internal/google"
  version = "3.1.0"
  # Health check to determine whether instances are responsive and able to do work
  health_check = {}
  # List of ports range to forward to backend services. Max is 5.
  ports = []
  # Time for which instance will be drained
  connection_draining_timeout_sec = 1
  # Service label is used to create internal DNS name
  service_label = ""
  # Name for the forwarding rule and prefix for supporting resources.
  name = ""
  # IP address of the internal load balancer, if empty one will be assigned. Default is empty.
  ip_address = ""
  # List of source ip ranges for traffic between the internal load balancer.
  source_ip_ranges = []
  # List of source tags for traffic between the internal load balancer.
  source_tags = []
  # List of backends, should be a map of key-value pairs for each backend, must have the 'group' key.
  backends = []
  # Boolean for all_ports setting on forwarding rule.
  all_ports = false
  # List of target service accounts for traffic between the internal load balancer.
  target_service_accounts = []
  # List of target tags for traffic between the internal load balancer.
  target_tags = []
  # List of source service accounts for traffic between the internal load balancer.
  source_service_accounts = []
}

module "nat-gateway2" {
  source  = "GoogleCloudPlatform/nat-gateway/google"
  version = "1.2.3"
  # The region to create the nat gateway instance in.
  region = ""
}

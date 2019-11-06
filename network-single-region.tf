# Single region network configuration | network-single-region.tf

# Define GCP Region
variable "gcp_region_1" {
  type = string
  description = "GCP region"
}

# Define GCP Zone
variable "gcp_zone_1" {
  type = string
  description = "GCP zone"
}

# Define Private Subnet
variable "private_subnet_cidr_1" {
  type = string
  description = "Private subnet CIDR 1"
}

# Define Public Subnet
variable "public_subnet_cidr_1" {
  type = string
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
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.private_subnet_cidr_1}",
    "${var.public_subnet_cidr_1}"
  ]
}

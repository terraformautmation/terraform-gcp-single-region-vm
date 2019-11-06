# Deploy a Google Cloud VM in a single region with Terraform

network-firewall.tf --> Configure basic firewall for the network

network-single-region.tf --> Define network, vpc, subnet, icmp firewall

provider.tf --> Configure Google Cloud provider

terraform.tfvars --> Defining variables 

variables-auth.tf --> Application and authentication variables

vm-output.tf --> Output of VM information

vm.tf --> Create a Ubuntu VM using Terraform

# Notes

Check list of Google Cloud OS images --> https://cloud.google.com/compute/docs/images

Create the Json file for authentication --> https://cloud.google.com/iam/docs/creating-managing-service-account-keys

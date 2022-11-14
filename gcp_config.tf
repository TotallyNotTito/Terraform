// Configure the Google Cloud provider
provider "google" {
 credentials = file("tf-lab.json")
 project     = "cloud-reinhart-tkral"
 region      = "us-west1"
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "tf-lab-vm"
 machine_type = "f1-micro"
 zone         = "us-west1-b"

 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-2004-focal-v20221018"
   }
 }

 network_interface {
   network = "default"
 }
}

resource "google_compute_address" "static" {
    name = "ipv4-address"
}

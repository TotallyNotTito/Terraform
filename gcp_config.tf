// Configure the Google Cloud provider
provider "google" {
 credentials = file("tf-lab.json")
 project     = "<FMI>"
 region      = "us-west1"
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "tf-lab-vm"
 machine_type = "f1-micro"
 zone         = "us-west1-b"
 metadata = {
    ssh-keys = "<FMI>:${file("~/.ssh/id_ed25519.pub")}"
 }
 metadata_startup_script = "${file("install.sh")}"
 tags = ["http-server"]
 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-2004-focal-v20221018"
   }
 }
}

 network_interface {
   network = "default"
   access_config {
     nat_ip = google_compute_address.static.address
   }
}

// A single IPv4 address
resource "google_compute_address" "static" {
  name = "ipv4-address"
}

// A variable for extracting the external IP address of the instance
output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

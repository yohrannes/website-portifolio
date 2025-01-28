provider "google" {
#  credentials = file("~/.gcp/credentials.json")
  project     = "website-portifolio"
  region      = "us-west1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "cd-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "cd-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_firewall" "default-allow-http-https-ssh-icmp" {
  name        = "cd-allow-http-https-ssh-icmp"
  network     = google_compute_network.vpc_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "inst-website-portifolio" {
  zone = "us-west1-a"
  boot_disk {
    auto_delete = true
    device_name = "inst-website-portifolio"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20241219"
      size  = 30
      type  = "pd-standard"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-micro"
  name         = "inst-website-portifolio"
  metadata = {
    startup-script = "${path.module}/startup-files/startup-script.sh"
    #ssh_authorized_keys = join("\n", [for k in local.ssh_authorized_keys : chomp(k)])
    #ssh_authorized_keys = file("/root/.ssh/id_rsa.pub")
    #user_data = base64encode(file("${path.module}/scripts/startup-script.sh"))
    #ssh-keys = join("\n", [
    #"user1:ssh-rsa ${chomp(file("~/.ssh/id_rsa.pub"))} user1@host.com",
    #"user2:ssh-rsa ${chomp(file("~/.ssh/another_key.pub"))} user2@host.com"
    #])
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      # network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }
}


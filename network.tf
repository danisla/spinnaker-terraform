# Copyright 2016 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_compute_network" "spinnaker-network" {
  name                    = "spinnaker-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "spinnaker-subnetwork" {
  name          = "${var.deployment_name}-spinnaker-subnetwork"
  ip_cidr_range = "${var.cidr_range}"
  network       = "${google_compute_network.spinnaker-network.self_link}"
}

resource "google_compute_firewall" "spinnaker-vm-fw" {
  name    = "spinnaker-vm-ssh"
  network = "${google_compute_network.spinnaker-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-ssh"]
}

resource "google_compute_firewall" "spinnaker-redis-fw" {
  name    = "redis-vm"
  network = "${google_compute_network.spinnaker-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  source_tags = ["spinnaker-vm"]
  target_tags = ["redis-vm"]
}

resource "google_compute_firewall" "spinnaker-jenkins-fw" {
  name    = "jenkins-vm-from-spinnaker"
  network = "${google_compute_network.spinnaker-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["spinnaker-vm"]
  target_tags = ["jenkins-vm"]
}

resource "google_compute_firewall" "spinnaker-jenkins-hc" {
  name    = "jenkins-vm-hc"
  network = "${google_compute_network.spinnaker-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22"]
  target_tags = ["jenkins-vm"]
}

resource "google_compute_firewall" "spinnaker-hc" {
  name    = "spinnaker-vm-hc"
  network = "${google_compute_network.spinnaker-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }

  source_ranges = ["130.211.0.0/22"]
  target_tags = ["spinnaker-vm"]
}

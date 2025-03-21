resource "google_compute_instance_template" "tpl" {
  name = var.template_name
  machine_type = var.machine_type

  disk {
      source_image = var.image
      auto_delete  = true
      disk_size_gb = var.disk_size
      boot         = true
  }
  network_interface {
    subnetwork = var.subnetwork
  }

  can_ip_forward = true

}

resource "google_compute_region_instance_group_manager" "mig" {
  name   = var.mig_name
  region = var.region
  base_instance_name = var.mig_name
  target_size = 3

  version {
    instance_template = google_compute_instance_template.tpl.self_link_unique
  }

  distribution_policy_zones = var.zones
}

resource "google_compute_region_health_check" "internal_hc" {
  name = "internal-health-check"

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_region_backend_service" "internal_backend" {
  name          = "internal-backend"
  region = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol      = "TCP"
  timeout_sec   = 10

  backend {
    group = google_compute_region_instance_group_manager.mig.self_link
  }

  health_checks = [google_compute_region_health_check.internal_hc.self_link]
}

resource "google_compute_forwarding_rule" "internal_lb" {
  name                  = "internal-forwarding-rule"
  load_balancing_scheme = "INTERNAL"
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  backend_service       = google_compute_region_backend_service.internal_backend.self_link
  ip_protocol           = "TCP"
  port_range            = "80"
}

resource "google_compute_address" "internal_ip" {
  name   = "internal-lb-ip"
  region = var.region
  subnetwork = var.subnetwork
  address_type = "INTERNAL"
}

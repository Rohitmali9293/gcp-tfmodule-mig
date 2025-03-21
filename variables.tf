variable "template_name" {
  description = "Name of the template"
  type = string  
}

variable "machine_type" {
  description = "machine type"
  type = string  
}


variable "disk_size" {
  description = "Size of the Boot Disk"
  type = number  
}

variable "image" {
  description = "image name"
  type = string  
  
}

variable "network" {
  description = "Subnetwork in which the VM Instance to be created"
  type = string
}

variable "mig_name" {
  description = "Name of the mig"
  type = string  
}

variable "zones" {
  description = "zone"
  type = list(string)
}

variable "region" {
  description = "Name of the region"
  type = string  
}

variable "subnetwork" {
  description = "Subnetwork in which the VM Instance to be created"
  type = string
}
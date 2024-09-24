variable "environment" {
  description = "Environment"
  default     = "sbx"
  type        = string
}

variable "docker_image_name" {
  description = "Docker Image name"
  default     = "frontend"
  type        = string
}

variable "docker_image_tag" {
  description = "Tag value of image in Docker Hub"
  default     = "latest"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub username"
  default     = "heathen1878"
  type        = string
}

variable "psql_admin_username" {
  description = "PostgreSQL admin username"
  type        = string
}

variable "psql_admin_password" {
  description = "PostgreSQL admin password"
  type        = string
}
variable "mariadb_root_password" {
  description = "MARIADB_ROOT_PASSWORD"
  type        = string
  default     = "matomo123"
}

variable "mariadb_user" {
  description = "MARIADB_USER"
  type        = string
  default     = "matomo"
}

variable "mariadb_password" {
  description = "MARIADB_PASSWORD"
  type        = string
  default     = "matomo123"
}

variable "mariadb_database" {
  description = "MARIADB_DATABASE"
  type        = string
  default     = "matomo"
}
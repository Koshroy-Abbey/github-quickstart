variable "abbey_token" {
  type = string
  sensitive = true
  description = "Abbey API Token"
}

variable "token" {
  type = string
  sensitive = true
  description = "OAuth or Personal Access Token"
}
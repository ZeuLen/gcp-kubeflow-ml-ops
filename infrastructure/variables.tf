variable "env" {
  type        = string
  description = "The environment we are building."
}

variable "project" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "pipeline_path" {
  type = string
}

variable "pipeline_name" {
  type = string
}

variable "schedule" {
  type = string
}

# tflint-ignore: terraform_unused_declarations
variable "labels" {
  type    = map(string)
  default = {}
}

variable "time_zone" {
  type    = string
  default = "Europe/Berlin"
}

variable "function_memory" {
  type    = number
  default = 8192
}




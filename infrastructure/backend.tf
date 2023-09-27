terraform {
  backend "gcs" {
    bucket = "customercloud-modelling-inf-gam-terraform-state"
  }
}

data "terraform_remote_state" "cdp-infrastructure" {
  backend = "gcs"
  config = {
    bucket = "customercloud-terraform-state"
    prefix = "env/${var.env}"
  }
}

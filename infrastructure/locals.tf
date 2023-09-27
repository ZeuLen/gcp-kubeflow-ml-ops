

locals {
  project_id          = data.google_project.project.project_id
  prod_project_id     = "cdp-customercloud-prod-1"
  # tflint-ignore: terraform_unused_declarations
  project_number      = data.google_project.project.number
  is_developer_branch = contains(regex("^(?:.*(developer))?.*$", var.env), "developer") #If env is developer-* , evaluates as true
}


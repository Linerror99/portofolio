project_name            = "portfolio"
environment             = "prod"
repository_name         = "app"
region                  = "us-west-1"
scan_on_push            = true
image_tag_mutability    = "MUTABLE"
enable_lifecycle_policy = true
image_retention_count   = 10

tags = {
  Owner      = "LDjossou"
  Purpose    = "ContainerRegistry"
  CostCenter = "Portfolio"
}

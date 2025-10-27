project_name            = "portfolio"
environment             = "prod"
repository_name         = "app"
gcp_project_id          = "portfolio-test-476200"
gcp_region              = "us-west1"
scan_on_push            = true
enable_lifecycle_policy = true
image_retention_count   = 10

tags = {
  owner      = "ldjossou"
  purpose    = "container-registry"
  costcenter = "portfolio"
}

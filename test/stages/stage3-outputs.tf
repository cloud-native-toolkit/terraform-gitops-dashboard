
resource null_resource write_outputs {
  provisioner "local-exec" {
    command = "echo \"$${OUTPUT}\" > gitops-output.json"

    environment = {
      OUTPUT = jsonencode({
        name        = module.gitops_dashboard.name
        branch      = module.gitops_dashboard.branch
        namespace   = module.gitops_dashboard.namespace
        server_name = module.gitops_dashboard.server_name
        layer       = module.gitops_dashboard.layer
        layer_dir   = module.gitops_dashboard.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_dashboard.layer == "services" ? "2-services" : "3-applications")
        type        = module.gitops_dashboard.type
      })
    }
  }
}

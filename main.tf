locals {
  bin_dir = module.setup_clis.bin_dir
  layer = "services"
  ingress_host = "dashboard-${var.namespace}.${var.cluster_ingress_hostname}"
  endpoint_url = "http${var.tls_secret_name != "" ? "s" : ""}://${local.ingress_host}"
  yaml_dir = "${path.cwd}/.tmp/dashboard"
  name = "dashboard"
  type = "base"
  tmp_dir = "${path.cwd}/.tmp/dashboard"
  application_branch = "main"
  global = {
    ingressSubdomain = var.cluster_ingress_hostname
    clusterType = var.cluster_type
    tlsSecretName = var.tls_secret_name
  }
  dashboard_config = {
    image = {
      tag = var.image_tag
    }
  }
  values_content = yamlencode({
    global = local.global
    developer-dashboard = var.image_tag != "" ? local.dashboard_config : {}
  })
  values_file = "values-${var.server_name}.yaml"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = local.values_content
      VALUES_SERVER_CONTENT = ""
    }
  }
}


resource gitops_module module {
  depends_on = [null_resource.create_yaml]

  name = local.name
  namespace = var.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}

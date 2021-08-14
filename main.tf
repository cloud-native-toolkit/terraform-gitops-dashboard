locals {
  bin_dir = "${path.cwd}/bin"
  layer = "services"
  ingress_host = "dashboard-${var.namespace}.${var.cluster_ingress_hostname}"
  endpoint_url = "http${var.tls_secret_name != "" ? "s" : ""}://${local.ingress_host}"
  yaml_dir = "${path.cwd}/.tmp/dashboard"
  name = "dashboard"
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
  values_server_content = yamlencode({
    global = local.global
    developer-dashboard = var.image_tag != "" ? local.dashboard_config : {}
  })
  values_file = "values-${var.server_name}.yaml"
}

resource null_resource setup_binaries {
  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-binaries.sh"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource null_resource create_yaml {
  depends_on = [null_resource.setup_binaries]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = ""
      VALUES_SERVER_CONTENT = local.values_server_content
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "$(command -v igc || command -v ${local.bin_dir}/igc) gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --valueFiles 'values.yaml,${local.values_file}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(var.git_credentials)
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}

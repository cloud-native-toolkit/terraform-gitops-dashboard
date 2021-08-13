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
  }
  dashboard_config = {
    sso = {
      enabled = true
    }
    image = {
      repository = "quay.io/ibmgaragecloud/developer-dashboard"
      tag = var.image_tag
    }
    tlsSecretName = var.tls_secret_name
  }
  tool_config = {
    name = "dashboard"
    url = local.endpoint_url
    applicationMenu = false
    displayName = "Developer Dashboard"
  }
  values_content = yamlencode({
    global = local.global
    developer-dashboard = local.dashboard_config
    tool-config = local.tool_config
  })
  values_file = "values-${var.serverName}.yaml"
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
      VALUES_CONTENT = local.values_content
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "$(command -v igc || command -v ${local.bin_dir}/igc) gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.serverName}' -l '${local.layer}' --valueFiles 'values.yaml,${local.values_file}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(var.git_credentials)
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}


variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "cluster_ingress_hostname" {
  type        = string
  description = "Ingress hostname of the IKS cluster."
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default     = "openshift"
}

variable "tls_secret_name" {
  type        = string
  description = "The name of the secret containing the tls certificate values"
  default     = ""
}

variable "image_tag" {
  type        = string
  description = "The image version tag to use"
  default     = "v1.4.4"
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

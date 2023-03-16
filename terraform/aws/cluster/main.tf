resource "kops_cluster" "cluster" {
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  cloud_provider {
    aws {}
  }

  # User sometime have diff TLD in their cluster name
  # If not given, use the subdomain
  dns_zone           = var.api_dns_zone != "" ? var.api_dns_zone : "${var.environment}.${var.domain_name}"
  network_id         = var.vpc_id
  network_cidr       = var.cidr

  non_masquerade_cidr = "100.64.0.0/10"

  ssh_access = [
    "0.0.0.0/0"
  ]

  kubernetes_api_access = [
    "0.0.0.0/0"
  ]

  cloud_config {
    aws_ebs_csi_driver {
      enabled = false
    }
  }

  # https://github.com/eddycharly/terraform-provider-kops/issues/530
  secrets {}

  authorization {
    rbac {}
  }

  api {
    load_balancer {
      type  = "Internal"
      class = "Network"
    }
  }

  kube_proxy {
    enabled              = true
    metrics_bind_address = "0.0.0.0"
    proxy_mode           = "ipvs"
  }

  # https://registry.terraform.io/providers/eddycharly/kops/latest/docs/resources/cluster#kubelet_config_spec
  kubelet {
    anonymous_auth {
      value = false
    }
    feature_gates = var.kubelet.feature_gates
  }

  # https://registry.terraform.io/providers/eddycharly/kops/latest/docs/resources/cluster#kube_scheduler_config
  kube_scheduler {
    feature_gates = var.kube_scheduler.feature_gates
  }

  # https://registry.terraform.io/providers/eddycharly/kops/latest/docs/resources/cluster#kube_controller_manager_config
  kube_controller_manager {
    feature_gates = var.kube_controller_manager.feature_gates
  }

  # https://registry.terraform.io/providers/eddycharly/kops/latest/docs/resources/cluster#kube_api_server_config
  kube_api_server {
    feature_gates = var.kube_api_server.feature_gates
    oidc_issuer_url = var.kube_api_server.oidc_issuer_url
    oidc_client_id = var.kube_api_server.oidc_client_id
    oidc_groups_claim = var.kube_api_server.oidc_groups_claim
    oidc_groups_prefix = var.kube_api_server.oidc_groups_prefix
  }

  iam {
    allow_container_registry = true
  }

  networking {
    calico {}
  }

  topology {
    masters = "private"
    nodes   = "private"

    dns {
      type = "Public"
    }
  }

  # private subnets
  dynamic "subnet" {
    for_each = var.private_subnets

    content {
      name        = "k8s-${var.environment}-private-${subnet.key}"
      type        = "Private"
      provider_id = subnet.value
      zone        = var.availability_zone_names[subnet.key]
    }
  }

  # public subnets
  dynamic "subnet" {
    for_each = var.public_subnets

    content {
      name        = "k8s-${var.environment}-utility-${subnet.key}"
      type        = "Utility"
      provider_id = subnet.value
      zone        = var.availability_zone_names[subnet.key]
    }
  }

  # etcd clusters
  etcd_cluster {
    name           = "main"
    memory_request = "100Mi"
    cpu_request    = "200m"

    dynamic "member" {
      for_each = [0, 1, 2]

      content {
        name             = "master-${member.key}"
        instance_group   = "master-${member.key}"
        encrypted_volume = true
      }
    }
  }

  etcd_cluster {
    name           = "events"
    memory_request = "100Mi"
    cpu_request    = "100m"

    dynamic "member" {
      for_each = [0, 1, 2]

      content {
        name             = "master-${member.key}"
        instance_group   = "master-${member.key}"
        encrypted_volume = true
      }
    }
  }
}

resource "kops_instance_group" "master-0" {
  cluster_name = kops_cluster.cluster.id
  name         = "master-0"
  role         = "Master"
  image        = var.master.image_id
  min_size     = var.master.min_size
  max_size     = var.master.max_size
  machine_type = var.master.machine_type
  node_labels  = var.master.node_labels
  cloud_labels = var.master.cloud_labels
  subnets      = ["k8s-${var.environment}-private-0"]
  depends_on   = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", flatten([["#!/bin/sh"], data.template_file.admin_ssh_keys.*.rendered]))
  }
}

resource "kops_instance_group" "master-1" {
  cluster_name = kops_cluster.cluster.id
  name         = "master-1"
  role         = "Master"
  image        = var.master.image_id
  min_size     = var.master.min_size
  max_size     = var.master.max_size
  machine_type = var.master.machine_type
  node_labels  = var.master.node_labels
  cloud_labels = var.master.cloud_labels
  subnets      = ["k8s-${var.environment}-private-1"]
  depends_on   = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", flatten([["#!/bin/sh"], data.template_file.admin_ssh_keys.*.rendered]))
  }
}

resource "kops_instance_group" "master-2" {
  cluster_name = kops_cluster.cluster.id
  name         = "master-2"
  role         = "Master"
  image        = var.master.image_id
  min_size     = var.master.min_size
  max_size     = var.master.max_size
  machine_type = var.master.machine_type
  node_labels  = var.master.node_labels
  cloud_labels = var.master.cloud_labels
  subnets      = ["k8s-${var.environment}-private-2"]
  depends_on   = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", flatten([["#!/bin/sh"], data.template_file.admin_ssh_keys.*.rendered]))
  }
}

resource "kops_instance_group" "node-0" {
  cluster_name      = kops_cluster.cluster.id
  name              = "node-0"
  role              = "Node"
  image             = var.worker.image_id
  min_size          = var.worker.min_size
  max_size          = var.worker.max_size
  machine_type      = var.worker.machine_type
  node_labels       = var.worker.node_labels
  cloud_labels      = var.worker.cloud_labels
  suspend_processes = var.worker.suspend_processes
  subnets           = [
    "k8s-${var.environment}-private-0",
    "k8s-${var.environment}-private-1",
    "k8s-${var.environment}-private-2"
  ]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", flatten([["#!/bin/sh"], data.template_file.admin_ssh_keys.*.rendered]))
  }
}

resource "kops_instance_group" "instance_group" {
  for_each          = var.instance_groups
  cluster_name      = kops_cluster.cluster.id
  name              = each.key
  role              = "Node"
  image             = each.value.image_id
  min_size          = each.value.min_size
  max_size          = each.value.max_size
  machine_type      = each.value.machine_type
  node_labels       = each.value.node_labels
  cloud_labels      = each.value.cloud_labels
  suspend_processes = each.value.suspend_processes
  taints            = each.value.taints
  max_price         = each.value.max_price
  zones             = each.value.zones
  subnets           = [ for subnet in each.value.subnets: "k8s-${var.environment}-private-${subnet}" ]
  depends_on        = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", flatten([["#!/bin/sh"], data.template_file.admin_ssh_keys.*.rendered]))
  }
}

data "template_file" "admin_ssh_keys" {
  template = file("templates/admin_ssh_keys.tpl")
  count = length(var.admin_ssh_keys)
  vars = {
    key = var.admin_ssh_keys[count.index]
  }
}


resource "kops_cluster_updater" "updater" {
  cluster_name = kops_cluster.cluster.id

  keepers = merge( {
    cluster  = kops_cluster.cluster.revision
    master-0 = kops_instance_group.master-0.revision
    master-1 = kops_instance_group.master-1.revision
    master-2 = kops_instance_group.master-2.revision
    node-0   = kops_instance_group.node-0.revision
  }, {
    for ig in kops_instance_group.instance_group : "ig_${ig.name}" => ig.revision
  } )

  rolling_update {
    skip                = false
    fail_on_drain_error = true
    fail_on_validate    = true
    validate_count      = 1
    validation_timeout  = "10m"
  }

  validate {
    skip    = false
    timeout = "10m"
  }
}

data "kops_kube_config" "kube_config" {
  cluster_name = kops_cluster.cluster.id
}

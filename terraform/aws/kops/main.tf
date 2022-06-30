resource "kops_cluster" "cluster" {
  name               = var.cluster_name
  cloud_provider     = "aws"
  kubernetes_version = var.kubernetes_version
  dns_zone           = "${var.environment}.${var.domain_name}"
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

  kubelet {
    anonymous_auth {
      value = false
    }
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
    name = "main"

    dynamic "member" {
      for_each = [0, 1, 2]

      content {
        name           = "master-${member.key}"
        instance_group = "master-${member.key}"
      }
    }
  }

  etcd_cluster {
    name = "events"

    dynamic "member" {
      for_each = [0, 1, 2]

      content {
        name           = "master-${member.key}"
        instance_group = "master-${member.key}"
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
  subnets      = ["k8s-${var.environment}-private-0"]
  depends_on   = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", data.template_file.admin_ssh_keys.*.rendered)
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
  subnets      = ["k8s-${var.environment}-private-1"]
  depends_on   = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", data.template_file.admin_ssh_keys.*.rendered)
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
  subnets      = ["k8s-${var.environment}-private-2"]
  depends_on   = [kops_cluster.cluster]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", data.template_file.admin_ssh_keys.*.rendered)
  }
}

resource "kops_instance_group" "node-0" {
  cluster_name = kops_cluster.cluster.id
  name         = "node-0"
  role         = "Node"
  image        = var.worker.image_id
  min_size     = var.worker.min_size
  max_size     = var.worker.max_size
  machine_type = var.worker.machine_type
  subnets      = ["k8s-${var.environment}-private-0", "k8s-${var.environment}-private-1", "k8s-${var.environment}-private-2"]

  additional_user_data {
    name    = "addPublicKey.sh"
    type    = "text/x-shellscript"
    content = join(" ", data.template_file.admin_ssh_keys.*.rendered)
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

  keepers = {
    cluster  = kops_cluster.cluster.revision
    master-0 = kops_instance_group.master-0.revision
    master-1 = kops_instance_group.master-1.revision
    master-2 = kops_instance_group.master-2.revision
    node-0   = kops_instance_group.node-0.revision
  }

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

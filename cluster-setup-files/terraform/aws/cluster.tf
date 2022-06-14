resource "kops_cluster" "cluster" {
  name               = var.cluster_name
  admin_ssh_key      = file("./ssh_pub.key")
  cloud_provider     = "aws"
  kubernetes_version = var.kubernetes_version
  dns_zone           = local.subdomain
  network_id         = module.vpc.vpc_id
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
      class = "Classic"
      type  = "Internal"
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
  subnet {
    name        = "k8s-${var.environment}-private-0"
    type        = "Private"
    provider_id = module.vpc.private_subnets[0]
    zone        = var.availability_zone_names[0]
  }
  subnet {
    name        = "k8s-${var.environment}-private-1"
    type        = "Private"
    provider_id = module.vpc.private_subnets[1]
    zone        = var.availability_zone_names[1]
  }
  subnet {
    name        = "k8s-${var.environment}-private-2"
    type        = "Private"
    provider_id = module.vpc.private_subnets[2]
    zone        = var.availability_zone_names[2]
  }

  # public subnets
  subnet {
    name        = "k8s-${var.environment}-utility-0"
    type        = "Utility"
    provider_id = module.vpc.public_subnets[0]
    zone        = var.availability_zone_names[0]
  }
  subnet {
    name        = "k8s-${var.environment}-utility-1"
    type        = "Utility"
    provider_id = module.vpc.public_subnets[1]
    zone        = var.availability_zone_names[1]
  }
  subnet {
    name        = "k8s-${var.environment}-utility-2"
    type        = "Utility"
    provider_id = module.vpc.public_subnets[2]
    zone        = var.availability_zone_names[2]
  }

  # etcd clusters
  etcd_cluster {
    name = "main"
    member {
      name           = "master-0"
      instance_group = "master-0"
    }
    member {
      name           = "master-1"
      instance_group = "master-1"
    }
    member {
      name           = "master-2"
      instance_group = "master-2"
    }
  }
  etcd_cluster {
    name = "events"
    member {
      name           = "master-0"
      instance_group = "master-0"
    }
    member {
      name           = "master-1"
      instance_group = "master-1"
    }
    member {
      name           = "master-2"
      instance_group = "master-2"
    }
  }

  depends_on = [
    aws_route53_record.subzone-ns-records,
    aws_instance.wireguard
  ]
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
    validation_timeout  = "2m"
  }

  validate {
    skip    = false
    timeout = "2m"
  }

  depends_on = [
    aws_route53_record.subzone-ns-records,
    aws_instance.wireguard
  ]
}

data "kops_kube_config" "kube_config" {
  cluster_name = kops_cluster.cluster.id
}

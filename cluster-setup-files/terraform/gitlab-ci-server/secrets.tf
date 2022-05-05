resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "random_password" "gitlab-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "gitlab-pat" {
  length  = 20
  special = false
}

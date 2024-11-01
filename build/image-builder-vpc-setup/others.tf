variable "args" {
  type = object({
		region = string

    credentials = object({
      access_key = string
      secret_key = string
    })
  })
}

locals {
  vpc_cidr = "10.0.0.0/16"
}

output "outputs" {
  value = {
		vpc_id 		= aws_vpc.default.id
		subnet_id = aws_subnet.public_subnet.id
	}
}

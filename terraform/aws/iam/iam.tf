data "aws_caller_identity" "current" {}

locals {
  accountid = data.aws_caller_identity.current.account_id
}

resource "random_pet" "this" {
  length = 2
}

module "ghci_iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.39.1"

  create_iam_user_login_profile = false

  name = "ghci-user"

  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

}

module "ghci_iam_user_access_key" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.1"

  name  = "/${var.environment}/secrets/iam/${module.ghci_iam_user.iam_user_name}/access_key"
  value = module.ghci_iam_user.iam_access_key_id
  # secure_type = true
}

module "ghci_iam_user_secret_key" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.1"

  name        = "/secrets/iam/${module.ghci_iam_user.iam_user_name}/secret_key"
  value       = module.ghci_iam_user.iam_access_key_secret
  secure_type = true
}
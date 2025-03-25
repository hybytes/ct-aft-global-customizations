module "ghci_iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.39.1"

  create_user = try(var.sqs.create_user, false)

  create_iam_user_login_profile = false

  name = "ghci-user-${var.environment}-${random_pet.this.id}"

  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  tags = local.tags
}

module "ghci_iam_user_access_key" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.1"

  create = try(var.sqs.create_user, false)

  name  = "/${var.environment}/secrets/iam/${module.ghci_iam_user.iam_user_name}/access_key"
  value = module.ghci_iam_user.iam_access_key_id
  # secure_type = true
}

module "ghci_iam_user_secret_key" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.1"

  create = try(var.sqs.create_user, false)

  name        = "/${var.environment}/secrets/iam/${module.ghci_iam_user.iam_user_name}/secret_key"
  value       = module.ghci_iam_user.iam_access_key_secret
  secure_type = true
}
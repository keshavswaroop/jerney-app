# resource "aws_iam_policy" "alb_controller" {
#   name = "AWSLoadBalancerControllerIAMPolicy"

#   policy = file("${path.module}/iam_policy.json")
# }

module "alb_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "alb-controller-role"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}


# This creares:
# IAM Role
# +
# Trust Relationship
# +
# Policy Attachment
# +
# OIDC linkage
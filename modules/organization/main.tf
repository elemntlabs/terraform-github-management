resource "github_organization_settings" "this" {
  name          = vars.organization_name
  company       = vars.company_name
  description   = vars.organization_description
  billing_email = var.billing_email

  blog             = vars.blog
  twitter_username = vars.twitter_user
}


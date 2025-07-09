resource "github_organization_settings" "this" {
  name          = var.organization_name
  company       = var.company_name
  description   = var.organization_description
  billing_email = var.billing_email

  blog             = var.blog_url
  twitter_username = var.twitter_username
}


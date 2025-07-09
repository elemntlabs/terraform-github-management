module "organization" {
  source                   = "../../modules/organization"
  organization_name        = "My GitHub Organization"
  company_name             = "My Company"
  organization_description = "A GitHub organization for managing projects"
  billing_email            = "billing@mycompany.com"
  blog_url                 = "https://mycompany.com/blog"
  twitter_username         = "mycompany"
}

output "organization_id" {
  value = module.organization.organization_id
}

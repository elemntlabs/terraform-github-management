module "organization" {
  source             = "../../modules/organization"
  project_name       = "My Organization Project"
  project_body       = "A project for managing my GitHub org"
  organization_description = "A GitHub organization for managing projects"
  webhook_url        = "https://example.com/webhook"
  events             = ["push", "pull_request"]
  twitter_user            = "mycompany"
}

output "organization_id" {
  value = module.organization.organization_id
}

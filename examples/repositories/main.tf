module "repositories" {
  source = "../../modules/repositories"

  repositories = {
    "my-webapp" = {
      description            = "A sample web application"
      visibility             = "public"
      has_issues             = true
      has_discussions        = true
      has_projects           = true
      has_wiki               = true
      allow_merge_commit     = true
      allow_squash_merge     = true
      allow_rebase_merge     = false
      delete_branch_on_merge = true
      auto_init              = true
      gitignore_template     = "Node"
      license_template       = "mit"
      topics                 = ["web", "application", "javascript"]
    }
    "my-api" = {
      description            = "REST API for the web application"
      visibility             = "private"
      has_issues             = true
      has_discussions        = false
      has_projects           = true
      has_wiki               = false
      allow_merge_commit     = false
      allow_squash_merge     = true
      allow_rebase_merge     = false
      delete_branch_on_merge = true
      auto_init              = true
      gitignore_template     = "Go"
      license_template       = "mit"
      topics                 = ["api", "rest", "golang"]
    }
    "documentation" = {
      description    = "Project documentation and guides"
      visibility     = "public"
      has_issues     = true
      has_wiki       = true
      auto_init      = true
      topics         = ["documentation", "guides"]
      pages = {
        source = {
          branch = "main"
          path   = "/docs"
        }
        build_type = "legacy"
      }
    }
  }

  default_branch_protection = {
    pattern                         = "main"
    enforce_admins                  = true
    require_signed_commits          = false
    required_linear_history         = false
    require_conversation_resolution = true
    required_status_checks = {
      strict   = true
      contexts = ["continuous-integration"]
    }
    required_pull_request_reviews = {
      dismiss_stale_reviews           = true
      restrict_dismissals             = false
      require_code_owner_reviews      = true
      required_approving_review_count = 1
      require_last_push_approval      = true
    }
  }

  collaborators = {
    "john-doe" = {
      repositories = ["my-webapp", "documentation"]
      permission   = "push"
    }
    "jane-smith" = {
      repositories = ["my-api"]
      permission   = "admin"
    }
  }

  team_repositories = {
    "developers" = {
      repositories = ["my-webapp", "my-api"]
      permission   = "push"
    }
    "maintainers" = {
      repositories = ["documentation"]
      permission   = "admin"
    }
  }
}

output "repositories" {
  value = module.repositories.repositories
}

output "repository_urls" {
  value = module.repositories.repository_urls
}
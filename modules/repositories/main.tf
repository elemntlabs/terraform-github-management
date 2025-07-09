resource "github_repository" "this" {
  for_each = var.repositories

  name                   = each.key
  description            = each.value.description
  visibility             = each.value.visibility
  has_issues             = each.value.has_issues
  has_discussions        = each.value.has_discussions
  has_projects           = each.value.has_projects
  has_wiki               = each.value.has_wiki
  allow_merge_commit     = each.value.allow_merge_commit
  allow_squash_merge     = each.value.allow_squash_merge
  allow_rebase_merge     = each.value.allow_rebase_merge
  allow_auto_merge       = each.value.allow_auto_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge
  auto_init              = each.value.auto_init
  gitignore_template     = each.value.gitignore_template
  license_template       = each.value.license_template
  archived               = each.value.archived
  archive_on_destroy     = each.value.archive_on_destroy
  topics                 = each.value.topics

  dynamic "template" {
    for_each = each.value.template != null ? [each.value.template] : []
    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }

  dynamic "pages" {
    for_each = each.value.pages != null ? [each.value.pages] : []
    content {
      source {
        branch = pages.value.source.branch
        path   = pages.value.source.path
      }
      build_type = pages.value.build_type
      cname      = pages.value.cname
    }
  }

  dynamic "security_and_analysis" {
    for_each = each.value.security_and_analysis != null ? [each.value.security_and_analysis] : []
    content {
      dynamic "advanced_security" {
        for_each = security_and_analysis.value.advanced_security != null ? [security_and_analysis.value.advanced_security] : []
        content {
          status = advanced_security.value.status
        }
      }
      dynamic "secret_scanning" {
        for_each = security_and_analysis.value.secret_scanning != null ? [security_and_analysis.value.secret_scanning] : []
        content {
          status = secret_scanning.value.status
        }
      }
      dynamic "secret_scanning_push_protection" {
        for_each = security_and_analysis.value.secret_scanning_push_protection != null ? [security_and_analysis.value.secret_scanning_push_protection] : []
        content {
          status = secret_scanning_push_protection.value.status
        }
      }
    }
  }
}

# Branch protection for repositories
resource "github_branch_protection" "this" {
  for_each = var.default_branch_protection != null ? var.repositories : {}

  repository_id                   = github_repository.this[each.key].name
  pattern                         = var.default_branch_protection.pattern
  enforce_admins                  = var.default_branch_protection.enforce_admins
  require_signed_commits          = var.default_branch_protection.require_signed_commits
  required_linear_history         = var.default_branch_protection.required_linear_history
  require_conversation_resolution = var.default_branch_protection.require_conversation_resolution

  dynamic "required_status_checks" {
    for_each = var.default_branch_protection.required_status_checks != null ? [var.default_branch_protection.required_status_checks] : []
    content {
      strict   = required_status_checks.value.strict
      contexts = required_status_checks.value.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = var.default_branch_protection.required_pull_request_reviews != null ? [var.default_branch_protection.required_pull_request_reviews] : []
    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      restrict_dismissals             = required_pull_request_reviews.value.restrict_dismissals
      dismissal_restrictions          = required_pull_request_reviews.value.dismissal_restrictions
      pull_request_bypassers          = required_pull_request_reviews.value.pull_request_bypassers
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
      require_last_push_approval      = required_pull_request_reviews.value.require_last_push_approval
    }
  }

  # Note: Push restrictions are managed via separate resources in newer provider versions
}

# Repository collaborators
resource "github_repository_collaborator" "this" {
  for_each = local.collaborator_permissions

  repository = each.value.repository
  username   = each.value.username
  permission = each.value.permission
}

# Team repository access
resource "github_team_repository" "this" {
  for_each = local.team_repository_permissions

  repository = each.value.repository
  team_id    = each.value.team_id
  permission = each.value.permission
}

locals {
  # Flatten collaborators and repositories for easy resource creation
  collaborator_permissions = merge([
    for username, config in var.collaborators : {
      for repo in config.repositories : "${username}-${repo}" => {
        username   = username
        repository = repo
        permission = config.permission
      }
    }
  ]...)

  # Flatten team repositories for easy resource creation
  team_repository_permissions = merge([
    for team_slug, config in var.team_repositories : {
      for repo in config.repositories : "${team_slug}-${repo}" => {
        team_id    = team_slug
        repository = repo
        permission = config.permission
      }
    }
  ]...)
}
# Repositories Module

## Overview

The `repositories` module allows you to manage GitHub repositories and their settings, including branch protection, collaborators, and team access. This module provides comprehensive repository management capabilities including security settings, collaboration features, and branch protection rules.

## Features

- **Repository Management**: Create and configure GitHub repositories with custom settings
- **Branch Protection**: Set up branch protection rules with required reviews and status checks
- **Collaborator Management**: Add individual collaborators with specific permissions
- **Team Repository Access**: Grant team-based repository access with defined permissions
- **Security Configuration**: Configure security and analysis features
- **GitHub Pages**: Set up GitHub Pages for documentation sites
- **Template Support**: Create repositories from existing templates

## Resources

This module creates and manages the following resources:

- `github_repository` - Creates and configures repositories
- `github_branch_protection` - Sets up branch protection rules
- `github_repository_collaborator` - Manages individual collaborators
- `github_team_repository` - Manages team-based repository access

## Variables

| Name                         | Type     | Description                                      | Default |
| ---------------------------- | -------- | ------------------------------------------------ | ------- |
| `repositories`               | `map(object)` | Map of repositories to create with their settings | `{}`    |
| `default_branch_protection`  | `object` | Default branch protection configuration          | `null`  |
| `collaborators`              | `map(object)` | Map of users and their repository permissions   | `{}`    |
| `team_repositories`          | `map(object)` | Map of teams and their repository permissions   | `{}`    |

### Repository Object Structure

Each repository in the `repositories` map supports the following configuration:

```hcl
{
  description          = string           # Repository description
  visibility           = string           # "public", "private", or "internal"
  has_issues           = bool             # Enable issues
  has_discussions      = bool             # Enable discussions
  has_projects         = bool             # Enable projects
  has_wiki             = bool             # Enable wiki
  allow_merge_commit   = bool             # Allow merge commits
  allow_squash_merge   = bool             # Allow squash merge
  allow_rebase_merge   = bool             # Allow rebase merge
  allow_auto_merge     = bool             # Allow auto-merge
  delete_branch_on_merge = bool           # Delete head branch on merge
  auto_init            = bool             # Initialize with README
  gitignore_template   = string           # Gitignore template name
  license_template     = string           # License template name
  archived             = bool             # Archive the repository
  archive_on_destroy   = bool             # Archive on destroy instead of delete
  topics               = list(string)     # Repository topics/tags
  template = {                            # Create from template
    owner      = string
    repository = string
  }
  pages = {                               # GitHub Pages configuration
    source = {
      branch = string
      path   = string
    }
    build_type = string
    cname      = string
  }
  security_and_analysis = {               # Security features
    advanced_security = {
      status = string
    }
    secret_scanning = {
      status = string
    }
    secret_scanning_push_protection = {
      status = string
    }
  }
}
```

### Branch Protection Configuration

The `default_branch_protection` variable configures branch protection rules:

```hcl
{
  pattern                         = string           # Branch pattern (e.g., "main")
  enforce_admins                  = bool             # Enforce rules for admins
  require_signed_commits          = bool             # Require signed commits
  required_linear_history         = bool             # Require linear history
  require_conversation_resolution = bool             # Require conversation resolution
  required_status_checks = {                         # Required status checks
    strict   = bool
    contexts = list(string)
  }
  required_pull_request_reviews = {                  # PR review requirements
    dismiss_stale_reviews           = bool
    restrict_dismissals             = bool
    dismissal_restrictions          = list(string)
    pull_request_bypassers          = list(string)
    require_code_owner_reviews      = bool
    required_approving_review_count = number
    require_last_push_approval      = bool
  }
  restrictions = {                                   # Push restrictions
    users = list(string)
    teams = list(string)
    apps  = list(string)
  }
}
```

## Outputs

| Name              | Description                           |
| ----------------- | ------------------------------------- |
| `repositories`    | Map of repository names to full details |
| `repository_names` | List of repository names             |
| `repository_urls` | Map of repository names to clone URLs |

## Example Usage

### Basic Repository Creation

```hcl
module "repositories" {
  source = "./modules/repositories"

  repositories = {
    "my-webapp" = {
      description     = "A sample web application"
      visibility      = "public"
      has_issues      = true
      has_discussions = true
      auto_init       = true
      topics          = ["web", "application"]
    }
    "my-api" = {
      description     = "REST API for the web application"
      visibility      = "private"
      has_issues      = true
      auto_init       = true
      topics          = ["api", "rest"]
    }
  }
}
```

### Repository with Branch Protection

```hcl
module "repositories" {
  source = "./modules/repositories"

  repositories = {
    "protected-repo" = {
      description = "Repository with branch protection"
      visibility  = "private"
      has_issues  = true
      auto_init   = true
    }
  }

  default_branch_protection = {
    pattern                         = "main"
    enforce_admins                  = true
    require_signed_commits          = false
    require_conversation_resolution = true
    required_status_checks = {
      strict   = true
      contexts = ["ci/build", "ci/test"]
    }
    required_pull_request_reviews = {
      dismiss_stale_reviews           = true
      require_code_owner_reviews      = true
      required_approving_review_count = 2
    }
  }
}
```

### Repository with Collaborators and Teams

```hcl
module "repositories" {
  source = "./modules/repositories"

  repositories = {
    "collaborative-repo" = {
      description = "Repository with multiple collaborators"
      visibility  = "private"
      has_issues  = true
      auto_init   = true
    }
  }

  collaborators = {
    "john-doe" = {
      repositories = ["collaborative-repo"]
      permission   = "push"
    }
    "jane-admin" = {
      repositories = ["collaborative-repo"]
      permission   = "admin"
    }
  }

  team_repositories = {
    "developers" = {
      repositories = ["collaborative-repo"]
      permission   = "push"
    }
  }
}
```

### Repository from Template

```hcl
module "repositories" {
  source = "./modules/repositories"

  repositories = {
    "new-from-template" = {
      description = "Repository created from template"
      visibility  = "private"
      template = {
        owner      = "octocat"
        repository = "Hello-World"
      }
    }
  }
}
```

### Repository with GitHub Pages

```hcl
module "repositories" {
  source = "./modules/repositories"

  repositories = {
    "docs-site" = {
      description = "Documentation site with GitHub Pages"
      visibility  = "public"
      has_wiki    = true
      auto_init   = true
      pages = {
        source = {
          branch = "main"
          path   = "/docs"
        }
        build_type = "legacy"
      }
    }
  }
}
```

## Permissions

The following repository permissions are supported:

- `pull` - Read access
- `triage` - Read access and ability to manage issues and pull requests
- `push` - Read, clone, and push to repository
- `maintain` - Push access and ability to manage some repository settings
- `admin` - Full administrative access

## Testing

### Validate Configuration

```bash
terraform validate
```

### Plan Changes

```bash
terraform plan
```

### Apply Changes

```bash
terraform apply
```

## GitHub Enterprise Compatibility

This module is compatible with both GitHub.com and GitHub Enterprise Server. When using with GitHub Enterprise, ensure your provider is configured with the appropriate `base_url`:

```hcl
provider "github" {
  base_url = "https://github.enterprise.com/api/v3/"
  token    = var.github_token
}
```

## Notes

- Branch protection rules apply to all repositories when `default_branch_protection` is configured
- Individual repository branch protection can be customized by extending the module
- Security and analysis features may require GitHub Advanced Security for private repositories
- Template repositories must be accessible to the authenticated user or organization
- GitHub Pages configuration requires the repository to be public or part of a GitHub Pro/Team/Enterprise plan
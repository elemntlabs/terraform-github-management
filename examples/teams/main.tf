module "teams" {
  source = "../../modules/teams"

  teams = {
    "developers" = {
      description = "Development team with push access to repositories"
      privacy     = "closed"
    }
    "maintainers" = {
      description = "Maintainers with admin access to repositories"
      privacy     = "closed"
    }
    "frontend-team" = {
      description   = "Frontend development team"
      privacy       = "closed"
      parent_team_id = null # Would be set to developers team ID if creating hierarchy
    }
    "backend-team" = {
      description   = "Backend development team"
      privacy       = "closed"
      parent_team_id = null # Would be set to developers team ID if creating hierarchy
    }
    "security" = {
      description = "Security team with special repository access"
      privacy     = "secret"
    }
  }

  team_memberships = {
    "developers" = {
      members = {
        "john-doe" = {
          role = "member"
        }
        "jane-smith" = {
          role = "maintainer"
        }
        "bob-wilson" = {
          role = "member"
        }
      }
    }
    "maintainers" = {
      members = {
        "jane-smith" = {
          role = "maintainer"
        }
        "admin-user" = {
          role = "maintainer"
        }
      }
    }
    "frontend-team" = {
      members = {
        "john-doe" = {
          role = "member"
        }
        "alice-frontend" = {
          role = "member"
        }
      }
    }
    "backend-team" = {
      members = {
        "bob-wilson" = {
          role = "member"
        }
        "charlie-backend" = {
          role = "member"
        }
      }
    }
    "security" = {
      members = {
        "security-lead" = {
          role = "maintainer"
        }
      }
    }
  }

  team_repositories = {
    "developers" = {
      repositories = {
        "my-webapp" = {
          permission = "push"
        }
        "my-api" = {
          permission = "push"
        }
      }
    }
    "maintainers" = {
      repositories = {
        "my-webapp" = {
          permission = "admin"
        }
        "my-api" = {
          permission = "admin"
        }
        "documentation" = {
          permission = "admin"
        }
      }
    }
    "frontend-team" = {
      repositories = {
        "my-webapp" = {
          permission = "push"
        }
        "documentation" = {
          permission = "push"
        }
      }
    }
    "backend-team" = {
      repositories = {
        "my-api" = {
          permission = "push"
        }
      }
    }
    "security" = {
      repositories = {
        "my-webapp" = {
          permission = "admin"
        }
        "my-api" = {
          permission = "admin"
        }
      }
    }
  }
}

output "teams" {
  value = module.teams.teams
}

output "team_ids" {
  value = module.teams.team_ids
}
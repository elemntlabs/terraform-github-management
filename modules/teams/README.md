# Teams Module

## Overview

The `teams` module allows you to manage GitHub teams, team memberships, and team repository permissions. This module provides comprehensive team management capabilities including team hierarchy, member roles, and repository access control.

## Features

- **Team Management**: Create and configure GitHub teams with custom settings
- **Team Hierarchy**: Support for parent-child team relationships
- **Membership Management**: Add members to teams with specific roles
- **Repository Access**: Grant team-based repository permissions
- **Privacy Controls**: Configure team visibility (open, closed, secret)
- **LDAP Integration**: Support for LDAP group synchronization (GitHub Enterprise)

## Resources

This module creates and manages the following resources:

- `github_team` - Creates and configures teams
- `github_team_membership` - Manages team memberships and roles
- `github_team_repository` - Manages team repository access permissions

## Variables

| Name                | Type         | Description                                    | Default |
| ------------------- | ------------ | ---------------------------------------------- | ------- |
| `teams`             | `map(object)` | Map of teams to create with their settings    | `{}`    |
| `team_memberships`  | `map(object)` | Map of team memberships with member roles     | `{}`    |
| `team_repositories` | `map(object)` | Map of team repository permissions            | `{}`    |

### Team Object Structure

Each team in the `teams` map supports the following configuration:

```hcl
{
  description               = string  # Team description
  privacy                   = string  # "closed", "secret"
  parent_team_id           = string  # Parent team ID for nested teams
  ldap_dn                  = string  # LDAP Distinguished Name (Enterprise only)
  create_default_maintainer = bool   # Create default maintainer
}
```

### Team Membership Structure

Team memberships are configured per team with member usernames and roles:

```hcl
{
  members = map(object({
    role = string  # "member" or "maintainer"
  }))
}
```

### Team Repository Permissions Structure

Team repository permissions are configured per team with repositories and permissions:

```hcl
{
  repositories = map(object({
    permission = string  # "pull", "triage", "push", "maintain", "admin"
  }))
}
```

## Outputs

| Name         | Description                        |
| ------------ | ---------------------------------- |
| `teams`      | Map of team names to full details  |
| `team_ids`   | Map of team names to their IDs     |
| `team_slugs` | Map of team names to their slugs   |

## Example Usage

### Basic Team Creation

```hcl
module "teams" {
  source = "./modules/teams"

  teams = {
    "developers" = {
      description = "Development team"
      privacy     = "closed"
    }
    "maintainers" = {
      description = "Repository maintainers"
      privacy     = "closed"
    }
  }
}
```

### Teams with Members

```hcl
module "teams" {
  source = "./modules/teams"

  teams = {
    "frontend-team" = {
      description = "Frontend development team"
      privacy     = "closed"
    }
    "backend-team" = {
      description = "Backend development team"
      privacy     = "closed"
    }
  }

  team_memberships = {
    "frontend-team" = {
      members = {
        "john-doe" = {
          role = "member"
        }
        "jane-lead" = {
          role = "maintainer"
        }
      }
    }
    "backend-team" = {
      members = {
        "bob-dev" = {
          role = "member"
        }
        "alice-senior" = {
          role = "maintainer"
        }
      }
    }
  }
}
```

### Teams with Repository Access

```hcl
module "teams" {
  source = "./modules/teams"

  teams = {
    "developers" = {
      description = "Development team"
      privacy     = "closed"
    }
    "security" = {
      description = "Security team"
      privacy     = "secret"
    }
  }

  team_memberships = {
    "developers" = {
      members = {
        "dev1" = { role = "member" }
        "dev2" = { role = "member" }
        "lead" = { role = "maintainer" }
      }
    }
    "security" = {
      members = {
        "security-expert" = { role = "maintainer" }
      }
    }
  }

  team_repositories = {
    "developers" = {
      repositories = {
        "web-app" = {
          permission = "push"
        }
        "api-service" = {
          permission = "push"
        }
      }
    }
    "security" = {
      repositories = {
        "web-app" = {
          permission = "admin"
        }
        "api-service" = {
          permission = "admin"
        }
        "security-tools" = {
          permission = "admin"
        }
      }
    }
  }
}
```

### Hierarchical Teams

```hcl
# First, create parent teams
module "parent_teams" {
  source = "./modules/teams"

  teams = {
    "engineering" = {
      description = "Engineering department"
      privacy     = "closed"
    }
  }
}

# Then create child teams
module "child_teams" {
  source = "./modules/teams"
  depends_on = [module.parent_teams]

  teams = {
    "frontend" = {
      description    = "Frontend engineering team"
      privacy        = "closed"
      parent_team_id = module.parent_teams.team_ids["engineering"]
    }
    "backend" = {
      description    = "Backend engineering team"
      privacy        = "closed"
      parent_team_id = module.parent_teams.team_ids["engineering"]
    }
  }
}
```

### Teams with LDAP Integration (GitHub Enterprise)

```hcl
module "teams" {
  source = "./modules/teams"

  teams = {
    "ldap-developers" = {
      description = "Development team synced with LDAP"
      privacy     = "closed"
      ldap_dn     = "cn=developers,ou=teams,dc=company,dc=com"
    }
  }
}
```

## Team Privacy Levels

| Privacy Level | Description                                      |
| ------------- | ------------------------------------------------ |
| `closed`      | Team is visible to organization members         |
| `secret`      | Team is only visible to team members            |

Note: `open` privacy level (visible to all organization members and they can request to join) is not supported in the current GitHub provider.

## Team Roles

| Role         | Permissions                                    |
| ------------ | ---------------------------------------------- |
| `member`     | Standard team member with basic permissions   |
| `maintainer` | Team maintainer with administrative permissions |

## Repository Permissions

| Permission | Description                                      |
| ---------- | ------------------------------------------------ |
| `pull`     | Read access to repository                        |
| `triage`   | Read access and ability to manage issues/PRs    |
| `push`     | Read, clone, and push access                     |
| `maintain` | Push access and some repository settings        |
| `admin`    | Full administrative access to repository         |

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

This module is fully compatible with GitHub Enterprise Server. Additional features available in Enterprise:

- **LDAP Integration**: Synchronize teams with LDAP groups using the `ldap_dn` parameter
- **SAML SSO**: Teams work seamlessly with SAML single sign-on
- **Advanced Auditing**: Team changes are logged in the audit log

For GitHub Enterprise, configure the provider with your enterprise URL:

```hcl
provider "github" {
  base_url = "https://github.enterprise.com/api/v3/"
  token    = var.github_token
}
```

## Best Practices

1. **Team Naming**: Use descriptive, consistent naming conventions
2. **Privacy Levels**: Use `secret` teams for sensitive access, `closed` for general teams
3. **Role Assignment**: Assign `maintainer` role to team leads and trusted members
4. **Repository Access**: Follow principle of least privilege when assigning repository permissions
5. **Team Hierarchy**: Use parent-child relationships to organize large teams
6. **Documentation**: Document team purposes and responsibilities

## Notes

- Team names must be unique within the organization
- Team slugs are automatically generated from team names
- Removing a team will also remove all team memberships and repository associations
- Parent teams automatically inherit access to child team repositories
- LDAP synchronization requires GitHub Enterprise Server with LDAP configured
- Team members must be organization members before being added to teams
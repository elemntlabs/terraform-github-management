resource "github_team" "this" {
  for_each = var.teams

  name                      = each.key
  description               = each.value.description
  privacy                   = each.value.privacy
  parent_team_id            = each.value.parent_team_id
  ldap_dn                   = each.value.ldap_dn
  create_default_maintainer = each.value.create_default_maintainer
}

resource "github_team_membership" "this" {
  for_each = local.team_memberships

  team_id  = github_team.this[each.value.team_name].id
  username = each.value.username
  role     = each.value.role
}

resource "github_team_repository" "this" {
  for_each = local.team_repositories

  team_id    = github_team.this[each.value.team_name].id
  repository = each.value.repository
  permission = each.value.permission
}

locals {
  # Flatten team memberships for easy resource creation
  team_memberships = merge([
    for team_name, config in var.team_memberships : {
      for username, member_config in config.members : "${team_name}-${username}" => {
        team_name = team_name
        username  = username
        role      = member_config.role
      }
    }
  ]...)

  # Flatten team repositories for easy resource creation
  team_repositories = merge([
    for team_name, config in var.team_repositories : {
      for repo_name, repo_config in config.repositories : "${team_name}-${repo_name}" => {
        team_name  = team_name
        repository = repo_name
        permission = repo_config.permission
      }
    }
  ]...)
}
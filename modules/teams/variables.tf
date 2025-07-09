variable "teams" {
  type = map(object({
    description      = optional(string, "")
    privacy          = optional(string, "closed")
    parent_team_id   = optional(string, null)
    ldap_dn          = optional(string, null)
    create_default_maintainer = optional(bool, false)
  }))
  description = "Map of teams to create"
  default     = {}
}

variable "team_memberships" {
  type = map(object({
    members = map(object({
      role = optional(string, "member")
    }))
  }))
  description = "Map of team memberships - team name to members with roles"
  default     = {}
}

variable "team_repositories" {
  type = map(object({
    repositories = map(object({
      permission = optional(string, "pull")
    }))
  }))
  description = "Map of team repository permissions - team name to repositories with permissions"
  default     = {}
}
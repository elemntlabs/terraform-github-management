variable "repositories" {
  type = map(object({
    description          = optional(string, "")
    visibility           = optional(string, "private")
    has_issues           = optional(bool, true)
    has_discussions      = optional(bool, false)
    has_projects         = optional(bool, true)
    has_wiki             = optional(bool, true)
    allow_merge_commit   = optional(bool, true)
    allow_squash_merge   = optional(bool, true)
    allow_rebase_merge   = optional(bool, true)
    allow_auto_merge     = optional(bool, false)
    delete_branch_on_merge = optional(bool, false)
    auto_init            = optional(bool, false)
    gitignore_template   = optional(string, null)
    license_template     = optional(string, null)
    archived             = optional(bool, false)
    archive_on_destroy   = optional(bool, true)
    topics               = optional(list(string), [])
    template = optional(object({
      owner      = string
      repository = string
    }), null)
    pages = optional(object({
      source = object({
        branch = string
        path   = optional(string, "/")
      })
      build_type = optional(string, "legacy")
      cname      = optional(string, null)
    }), null)
    security_and_analysis = optional(object({
      advanced_security = optional(object({
        status = string
      }), null)
      secret_scanning = optional(object({
        status = string
      }), null)
      secret_scanning_push_protection = optional(object({
        status = string
      }), null)
    }), null)
  }))
  description = "Map of repositories to create"
  default     = {}
}

variable "default_branch_protection" {
  type = object({
    pattern                         = optional(string, "main")
    enforce_admins                  = optional(bool, true)
    require_signed_commits          = optional(bool, false)
    required_linear_history         = optional(bool, false)
    require_conversation_resolution = optional(bool, false)
    required_status_checks = optional(object({
      strict   = optional(bool, false)
      contexts = optional(list(string), [])
    }), null)
    required_pull_request_reviews = optional(object({
      dismiss_stale_reviews           = optional(bool, false)
      restrict_dismissals             = optional(bool, false)
      dismissal_restrictions          = optional(list(string), [])
      pull_request_bypassers          = optional(list(string), [])
      require_code_owner_reviews      = optional(bool, false)
      required_approving_review_count = optional(number, 1)
      require_last_push_approval      = optional(bool, false)
    }), null)
    restrictions = optional(object({
      users = optional(list(string), [])
      teams = optional(list(string), [])
      apps  = optional(list(string), [])
    }), null)
  })
  description = "Default branch protection configuration"
  default     = null
}

variable "collaborators" {
  type = map(object({
    repositories = list(string)
    permission   = optional(string, "push")
  }))
  description = "Map of users and their repository permissions"
  default     = {}
}

variable "team_repositories" {
  type = map(object({
    repositories = list(string)
    permission   = optional(string, "push")
  }))
  description = "Map of teams and their repository permissions"
  default     = {}
}
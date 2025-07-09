output "repositories" {
  description = "Map of repository names to their full details"
  value = {
    for name, repo in github_repository.this : name => {
      id              = repo.id
      name            = repo.name
      full_name       = repo.full_name
      description     = repo.description
      visibility      = repo.visibility
      clone_url       = repo.clone_url
      ssh_clone_url   = repo.ssh_clone_url
      git_clone_url   = repo.git_clone_url
      http_clone_url  = repo.http_clone_url
      default_branch  = repo.default_branch
      node_id         = repo.node_id
      repo_id         = repo.repo_id
      topics          = repo.topics
    }
  }
}

output "repository_names" {
  description = "List of repository names"
  value       = keys(github_repository.this)
}

output "repository_urls" {
  description = "Map of repository names to their URLs"
  value = {
    for name, repo in github_repository.this : name => {
      clone_url      = repo.clone_url
      ssh_clone_url  = repo.ssh_clone_url
      git_clone_url  = repo.git_clone_url
      http_clone_url = repo.http_clone_url
    }
  }
}
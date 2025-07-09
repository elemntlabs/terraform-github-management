output "teams" {
  description = "Map of team names to their details"
  value = {
    for name, team in github_team.this : name => {
      id          = team.id
      node_id     = team.node_id
      slug        = team.slug
      name        = team.name
      description = team.description
      privacy     = team.privacy
      etag        = team.etag
    }
  }
}

output "team_ids" {
  description = "Map of team names to their IDs"
  value = {
    for name, team in github_team.this : name => team.id
  }
}

output "team_slugs" {
  description = "Map of team names to their slugs"
  value = {
    for name, team in github_team.this : name => team.slug
  }
}
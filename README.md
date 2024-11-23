# Terraform GitHub Management Module

This repository contains Terraform modules for managing GitHub resources, including organization settings,
repositories, teams, and team memberships. It is designed to simplify and automate the management of your GitHub
organization using Infrastructure as Code (IaC).

---

## Features

- **Organization Management**: Configure organization-level projects and webhooks.
- **Repository Management**: Create, manage, and customize GitHub repositories.
- **Team Management**: Define teams, set privacy levels, and manage team memberships.
- **Scalable Design**: Modular structure allows you to use individual components or the entire module.

## Repository Structure

```plaintext
terraform-github-management/
├── modules/
│   ├── organization/      # Organization-related resources
│   ├── repositories/      # Repository-related resources
│   └── teams/             # Team-related resources
├── examples/              # Example usage of each module
│   ├── organization-settings/
│   ├── repositories/
│   └── teams/
├── README.md              # This documentation
├── LICENSE                # Licensing information
├── versions.tf            # Required Terraform and provider versions
```

## Prerequisites

1. **Terraform**: Ensure you have Terraform version `~> 1.9.0` installed.
   ```bash
   terraform --version
   ```
2. **GitHub Provider**: Install the Terraform GitHub provider.

3. **Authentication**: Export your GitHub personal access token with the required permissions:
   ```bash
   export GITHUB_TOKEN="your_github_personal_access_token"
   ```
   Required scopes:
   - `read:org`
   - `repo`
   - `admin:org`

## Modules

### [Organization](./modules/organization/README.md)

The `organization` submodule allows you to manage the settings of your GitHub organization.
It configures details such as the organization name, description, billing email, and social media links.

#### Variables

| Name                       | Type     | Description                                               |
| -------------------------- | -------- | --------------------------------------------------------- |
| `organization_name`        | `string` | The name of the GitHub organization.                      |
| `company_name`             | `string` | The name of the company associated with the organization. |
| `organization_description` | `string` | A description of the organization.                        |
| `billing_email`            | `string` | The billing email address for the organization.           |
| `blog`                     | `string` | URL to the organization's blog or website.                |
| `twitter_user`             | `string` | The Twitter username for the organization or company.     |

## Example Usage

### Organization Settings

```hcl
module "organization" {
  source                  = "./modules/organization"
  organization_name       = "My GitHub Organization"
  company_name            = "My Company"
  organization_description = "A GitHub organization for managing projects"
  billing_email           = "billing@mycompany.com"
  blog                    = "https://mycompany.com/blog"
  twitter_user            = "mycompany"
}

output "organization_id" {
  value = module.organization.organization_id
}
```

## Testing

1. **Validate Configuration**:

   ```bash
   terraform validate
   ```

2. **Plan Changes**:

   ```bash
   terraform plan
   ```

3. **Apply Changes**:

   ```bash
   terraform apply
   ```

4. **Automated Tests**:
   Use `terratest` or similar frameworks for integration tests.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contributing

We welcome contributions! Please fork the repository, create a feature branch, and submit a pull request.

## Maintainers

This module is maintained by [Endalkachew Biruk](https://github.com/endalk200).

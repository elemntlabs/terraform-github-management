# Organization Submodule

## Overview

The `organization` submodule allows you to manage the settings of your GitHub organization. It configures details such as the organization name, description, billing email, and social media links.

## Features

- Set organization-level details including company name, billing email, and social media profiles.
- Manage the basic configuration of a GitHub organization.
- Output the GitHub organization ID.

## Resources

This submodule utilizes the `github_organization_settings` resource to configure organization settings. The following attributes are configurable:

- `name`: The name of the organization.
- `company`: The company name associated with the organization.
- `description`: A description of the organization.
- `billing_email`: The billing email address for the organization.
- `blog`: URL for the organization's blog or website.
- `twitter_username`: The Twitter handle for the organization.

## Outputs

| Name              | Type     | Description                               |
| ----------------- | -------- | ----------------------------------------- |
| `organization_id` | `string` | The unique ID of the GitHub organization. |

## Variables

| Name                       | Type     | Description                                               |
| -------------------------- | -------- | --------------------------------------------------------- |
| `organization_name`        | `string` | The name of the GitHub organization.                      |
| `company_name`             | `string` | The name of the company associated with the organization. |
| `organization_description` | `string` | A description of the organization.                        |
| `billing_email`            | `string` | The billing email address for the organization.           |
| `blog`                     | `string` | URL to the organization's blog or website.                |
| `twitter_user`             | `string` | The Twitter username for the organization or company.     |

## Example Usage

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

### Explanation:

- **`organization_name`**: The name of the organization.
- **`company_name`**: The company name for the organization.
- **`organization_description`**: A brief description of the organization.
- **`billing_email`**: The email address for billing purposes.
- **`blog`**: URL to the company’s blog or website.
- **`twitter_user`**: The Twitter handle associated with the company or organization.

## Outputs

- **`organization_id`**: This output provides the unique ID of the GitHub organization, which can be used in other modules or for reference.

## Testing

### Validate Configuration

Run the following command to validate your Terraform configuration:

```bash
terraform validate
```

### Plan Changes

To preview the changes that will be made:

```bash
terraform plan
```

### Apply Changes

Apply the configuration changes to your GitHub organization:

```bash
terraform apply
```

---

## Resource Details

The `github_organization_settings` resource is used to configure the settings for the GitHub organization. The following parameters are set based on the provided variables:

- **`name`**: Organization's name.
- **`company`**: The name of the company.
- **`description`**: Organization's description.
- **`billing_email`**: Organization's billing email.
- **`blog`**: URL to the organization's blog.
- **`twitter_username`**: The Twitter username associated with the organization.

## Outputs

- **`organization_id`**: The unique ID of the organization, accessible via `module.organization.organization_id`.

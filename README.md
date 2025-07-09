# Terraform GitHub Management Modules

A comprehensive collection of Terraform modules for managing GitHub resources, including organization settings, repositories, teams, and team memberships. This project simplifies and automates GitHub organization management using Infrastructure as Code (IaC) principles.

[![GitHub Release](https://img.shields.io/github/v/release/elemntlabs/terraform-github-management)](https://github.com/elemntlabs/terraform-github-management/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.9.0-blue)](https://www.terraform.io/downloads.html)
[![GitHub Provider](https://img.shields.io/badge/github_provider-%7E%3E6.4-blue)](https://registry.terraform.io/providers/integrations/github/latest)
[![License](https://img.shields.io/github/license/elemntlabs/terraform-github-management)](./LICENSE)

---

## ✨ Features

- **🏢 Organization Management**: Configure organization-level settings, company information, and social profiles
- **📦 Repository Management**: Create, configure, and secure GitHub repositories with comprehensive settings
- **👥 Team Management**: Define teams, manage memberships, and control repository access
- **🔒 Security Controls**: Implement branch protection rules, security scanning, and access controls
- **🔧 Enterprise Ready**: Full compatibility with GitHub Enterprise Server and GitHub.com
- **📚 Modular Design**: Use individual modules independently or combine them for complete GitHub management

## 🏗️ Repository Structure

```plaintext
terraform-github-management/
├── modules/
│   ├── organization/      # Organization settings and configuration
│   ├── repositories/      # Repository creation and management
│   └── teams/             # Team creation and membership management
├── examples/              # Example configurations for each module
│   ├── organization-settings/
│   ├── repositories/
│   └── teams/
├── README.md              # This documentation
├── LICENSE                # MIT License
└── version.tf             # Provider and Terraform version constraints
```

## 📋 Prerequisites

1. **Terraform**: Version `>= 1.9.0`
   ```bash
   terraform --version
   ```

2. **GitHub Provider**: Version `~> 6.4` (automatically installed)

3. **GitHub Authentication**: Personal Access Token or GitHub App
   ```bash
   export GITHUB_TOKEN="your_github_personal_access_token"
   ```

   **Required Token Scopes:**
   - `repo` - Full repository access
   - `admin:org` - Organization administration
   - `read:org` - Organization read access
   - `user` - User profile access (for membership management)

4. **Permissions**: Organization owner or appropriate admin permissions for the resources you want to manage

## 🚀 Quick Start

### 1. Basic Organization Setup

```hcl
module "organization" {
  source = "github.com/elemntlabs/terraform-github-management//modules/organization"

  organization_name        = "my-awesome-org"
  company_name             = "My Company Inc."
  organization_description = "Building amazing software together"
  billing_email            = "billing@mycompany.com"
  blog_url                 = "https://mycompany.com/blog"
  twitter_username         = "mycompany"
}
```

### 2. Create Repositories

```hcl
module "repositories" {
  source = "github.com/elemntlabs/terraform-github-management//modules/repositories"

  repositories = {
    "web-frontend" = {
      description = "Frontend application"
      visibility  = "public"
      has_issues  = true
      auto_init   = true
      topics      = ["react", "frontend", "web"]
    }
    "api-backend" = {
      description = "Backend API service"
      visibility  = "private"
      has_issues  = true
      auto_init   = true
      topics      = ["golang", "api", "backend"]
    }
  }

  default_branch_protection = {
    pattern                         = "main"
    enforce_admins                  = true
    require_conversation_resolution = true
    required_pull_request_reviews = {
      required_approving_review_count = 1
      require_code_owner_reviews      = true
    }
  }
}
```

### 3. Manage Teams

```hcl
module "teams" {
  source = "github.com/elemntlabs/terraform-github-management//modules/teams"

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

  team_memberships = {
    "developers" = {
      members = {
        "alice" = { role = "member" }
        "bob"   = { role = "member" }
        "carol" = { role = "maintainer" }
      }
    }
  }

  team_repositories = {
    "developers" = {
      repositories = {
        "web-frontend" = { permission = "push" }
        "api-backend"  = { permission = "push" }
      }
    }
  }
}
```

## 📖 Module Documentation

### [Organization Module](./modules/organization/README.md)

Manages GitHub organization settings and configuration.

**Key Features:**
- Organization profile and company information
- Billing and contact details
- Social media integration
- Organization-level settings

**Example:**
```hcl
module "organization" {
  source = "./modules/organization"
  
  organization_name        = "ACME Corp"
  company_name             = "ACME Corporation"
  organization_description = "Making the world better with software"
  billing_email            = "billing@acme.com"
  blog_url                 = "https://acme.com/blog"
  twitter_username         = "acmecorp"
}
```

### [Repositories Module](./modules/repositories/README.md)

Comprehensive repository management with security and collaboration features.

**Key Features:**
- Repository creation and configuration
- Branch protection rules
- Collaborator and team access management
- Security and analysis features
- GitHub Pages support
- Template repository support

**Example:**
```hcl
module "repositories" {
  source = "./modules/repositories"
  
  repositories = {
    "awesome-project" = {
      description = "An awesome open source project"
      visibility  = "public"
      has_issues  = true
      topics      = ["awesome", "open-source"]
    }
  }
  
  default_branch_protection = {
    pattern                         = "main"
    required_pull_request_reviews = {
      required_approving_review_count = 2
    }
  }
}
```

### [Teams Module](./modules/teams/README.md)

Complete team management with hierarchical support and permission control.

**Key Features:**
- Team creation and configuration
- Team membership management
- Repository access control
- Team hierarchy support
- LDAP integration (GitHub Enterprise)

**Example:**
```hcl
module "teams" {
  source = "./modules/teams"
  
  teams = {
    "frontend-team" = {
      description = "Frontend development team"
      privacy     = "closed"
    }
  }
  
  team_memberships = {
    "frontend-team" = {
      members = {
        "developer1" = { role = "member" }
        "lead-dev"   = { role = "maintainer" }
      }
    }
  }
}
```

## 🏢 GitHub Enterprise Support

All modules are fully compatible with GitHub Enterprise Server. Configure the provider for your enterprise instance:

```hcl
provider "github" {
  base_url = "https://github.enterprise.com/api/v3/"
  token    = var.github_token
}
```

**Enterprise-Specific Features:**
- LDAP team synchronization
- SAML SSO integration
- Advanced security and compliance features
- Enterprise-specific repository settings

## 🔧 Advanced Configuration

### Using All Modules Together

```hcl
# Configure the provider
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.4"
    }
  }
  required_version = ">= 1.9.0"
}

provider "github" {
  token = var.github_token
}

# Organization setup
module "organization" {
  source = "./modules/organization"
  
  organization_name        = var.org_name
  company_name             = var.company_name
  organization_description = var.org_description
  billing_email            = var.billing_email
  blog_url                 = var.blog_url
  twitter_username         = var.twitter_username
}

# Create teams first
module "teams" {
  source = "./modules/teams"
  
  teams             = var.teams
  team_memberships  = var.team_memberships
  team_repositories = var.team_repositories
}

# Create repositories with team access
module "repositories" {
  source = "./modules/repositories"
  depends_on = [module.teams]
  
  repositories              = var.repositories
  default_branch_protection = var.branch_protection
  collaborators            = var.collaborators
  team_repositories        = var.team_repository_access
}
```

### Variables File Example

```hcl
# variables.tf
variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "org_name" {
  description = "GitHub organization name"
  type        = string
}

variable "teams" {
  description = "Teams configuration"
  type = map(object({
    description = string
    privacy     = string
  }))
}

variable "repositories" {
  description = "Repositories configuration"
  type = map(object({
    description = string
    visibility  = string
    has_issues  = bool
    topics      = list(string)
  }))
}
```

## 🧪 Testing

### Validation

```bash
# Validate all modules
terraform validate

# Validate specific module
cd modules/repositories && terraform validate
```

### Plan and Apply

```bash
# See what changes will be made
terraform plan

# Apply changes
terraform apply

# Apply with auto-approval (use carefully)
terraform apply -auto-approve
```

### Automated Testing

We recommend using [Terratest](https://terratest.gruntwork.io/) for automated testing:

```go
func TestRepositoriesModule(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/repositories",
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    // Add your assertions here
}
```

## 📝 Examples

Complete examples are available in the [`examples/`](./examples/) directory:

- **[Organization Settings](./examples/organization-settings/)** - Basic organization configuration
- **[Repository Management](./examples/repositories/)** - Comprehensive repository setup with security
- **[Team Management](./examples/teams/)** - Team creation with members and permissions

Each example includes:
- Complete Terraform configuration
- Variable definitions
- Expected outputs
- Usage instructions

## 🔒 Security Best Practices

1. **Token Security**: Never commit GitHub tokens to version control
2. **Principle of Least Privilege**: Grant minimum necessary permissions
3. **Branch Protection**: Enable branch protection on all important repositories
4. **Required Reviews**: Require code reviews for all changes
5. **Status Checks**: Implement CI/CD status checks
6. **Team Permissions**: Use teams instead of individual collaborators when possible

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](./CONTRIBUTING.md) for details.

### Development Setup

1. Fork this repository
2. Clone your fork: `git clone https://github.com/yourusername/terraform-github-management.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes and test them
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Code Quality

- Follow Terraform best practices
- Include comprehensive documentation
- Add examples for new features
- Ensure all modules validate successfully
- Write clear commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 👥 Maintainers

This project is maintained by [Endalkachew Biruk](https://github.com/endalk200) at [Elemnt Labs](https://github.com/elemntlabs).

### Support

- 📫 **Issues**: [GitHub Issues](https://github.com/elemntlabs/terraform-github-management/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/elemntlabs/terraform-github-management/discussions)
- 📖 **Documentation**: [Module Documentation](./modules/)

## 🙏 Acknowledgments

- HashiCorp for Terraform
- GitHub for the GitHub Terraform Provider
- The open-source community for inspiration and contributions

---

**Made with ❤️ by [Elemnt Labs](https://github.com/elemntlabs)**

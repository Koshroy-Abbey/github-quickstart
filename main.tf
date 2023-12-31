terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.2.4"
    }

    github = {
      source = "integrations/github"
      version = "5.28.0"
    }
  }
}

provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}

provider "github" {
  owner = "Koshroy-Abbey" #CHANGEME
  token = var.token
}

resource "abbey_grant_kit" "engineering_abbey_test_github_team" {
  name = "GitHub_Team_Abbey_Test"
  description = <<-EOT
    This resource represents a GitHub Team Membership for engineers looking to test Abbey.

    This Grant Kit grants access and expires it automatically after 24 hours.
  EOT

  workflow = {
    steps = [
      {
        reviewers = {
          # Replace with your Abbey login, typically your email used to sign up.
          one_of = ["koushik@abbey.io"]
        }
      }
    ]
  }

  policies = [
    {
      # Optionally, you can build an OPA bundle and keep it in your repo.
      # `opa build -b policies/common -o policies/common.tar.gz`
      #
      # If you do, you can then specify `bundle` with:
      # bundle = "github://organization/repo/policies/common.tar.gz"
      #
      # Otherwise you can specify the directory. Abbey will build an
      # OPA bundle for you and recursively add all your policies.
      bundle = "github://organization/repo/policies"
    }
  ]

  output = {
    # Replace with your own path pointing to where you want your access changes to manifest.
    # Path is an RFC 3986 URI, such as `github://{organization}/{repo}/path/to/file.tf`.
    location = "github://Koshroy-Abbey/github-quickstart/access.tf"
    append = <<-EOT
      resource "github_team_membership" "gh_mem_{{ .user.github.username }}" { # {{ .user.email }}
        team_id = 1234567
        username = "{{ .user.github.username }}"
        role = "member"
      }
    EOT
  }
}

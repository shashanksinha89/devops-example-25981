terraform {
  backend "pg" {
  }
}

terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 4.0"
    }
  }
}

#provider "heroku" {
#  email   = "${var.heroku_username}" 
#  api_key = "${var.heroku_api_key}"
#}


variable "example_app_name" {
  description = "Name of the Heroku app provisioned as an example"
  default     = "shashank123456789"
}

resource "heroku_app" "example" {
  name   = var.example_app_name
  region = "us"
  stack  = "container"
  config_vars = {
    SECRET_KEY = "build"
  }
}

resource "heroku_addon" "database" {
  app        = heroku_app.example.name
  plan       = "heroku-postgresql:hobby-dev"
  depends_on = [heroku_app.example]
}

resource "heroku_addon" "redis" {
  app        = heroku_app.example.name
  plan       = "heroku-redis:hobby-dev"
  depends_on = [heroku_app.example]
}

resource "heroku_addon" "scheduler" {
  app        = heroku_app.example.name
  plan       = "scheduler:standard"
  depends_on = [heroku_app.example]
}

# Build code & release to the app
resource "heroku_build" "example" {
  app = heroku_app.example.name
  #  buildpacks = ["https://github.com/mars/create-react-app-buildpack.git"]

  source {
    #url = "https://github.com/shashanksinha89/devops-example-25981"
    path = "src/app"
  }
}

# Launch the app's web process by scaling-up
resource "heroku_formation" "example" {
  app      = heroku_app.example.name
  type     = "web"
  quantity = 1
  #size       = "Standard-1x"
  size       = "hobby"
  depends_on = [heroku_build.example]
}

output "app_url" {
  value = "https://${heroku_app.example.name}.herokuapp.com"
}
output "app_name" {
  value = heroku_app.example.id
}
output "app_id" {
  value = heroku_app.example.uuid
}



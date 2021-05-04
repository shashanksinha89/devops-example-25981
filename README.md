# devops_example_25981

This repo contains terraform files to deploy [django app](https://github.com/shashanksinha89/devops-example-25981/tree/master/src/app) using github actions. 


```sh
.
├── .github
│   └── workflows
│       ├── build-v1.yml
│       ├── build.yml
├── .terraform.lock.hcl
├── README.md
├── main.tf
└── src
    └── app
        ├── .dockerignore
        ├── .env
        ├── .env.example
        ├── .pytest_cache
        ├── Dockerfile
        ├── Pipfile
        ├── Pipfile.lock
        ├── README.md
        ├── devops_example_25981
        ├── docker-compose.override.yml
        ├── docker-compose.yml
        ├── heroku.yml
        ├── home
        ├── manage.py
        ├── modules
        ├── postgres-data
        ├── static
        ├── staticfiles
        └── users
```

# Setup

Following are instructions on setting up your environment.

### Prerequsites
-  [Terraform](https://www.terraform.io/downloads.html)
-  [Heroku Cli](https://devcenter.heroku.com/articles/heroku-cli)

### Steps
1. Generate Heroku Authorization and Terraform backend store

```sh
heroku authorizations:create --description terraform-my-app
```

```sh
APP_NAME=<Define app name>
heroku addons:create heroku-postgresql:hobby-dev --app $APP_NAME
```

2. Setup Github Secrets for Heroku:
   - `DATABASE_URL` - This is needed to store terraform remote file state.
   - `HEROKU_API_KEY` - Store the authorziation token generated 
   - `HEROKU_EMAIL` - Email id for heroku account
3. Setup Github Secrets for App:
   - `SECRET_KEY`

4. Github Actions CI/CD setup is now ready and can be triggered with push to master branch or manually from actions tab.

### Github Actions

There are 2 Actions defined in this repo

- [Deployment with unit test](https://github.com/shashanksinha89/devops-example-25981/blob/master/.github/workflows/build.yml)
- [Deployment with no unit test](https://github.com/shashanksinha89/devops-example-25981/blob/master/.github/workflows/build-v1.yml)


### Terraform Output

```sh
heroku_build.example: Still creating... [4m10s elapsed]
heroku_build.example: Still creating... [4m20s elapsed]
heroku_build.example: Still creating... [4m30s elapsed]
heroku_build.example: Creation complete after 4m34s [id=74b5d9f5-943e-4040-a96f-84dfe964d983]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

app_id = "9b4a5cd9-4ee4-42d3-8476-20f7a9fc3bee"
app_name = "shashank123456789"
app_url = "https://shashank123456789.herokuapp.com"
```

## Running Terraform Deployment locally

### Steps

1. export `HEROKU_API_KEY`=`<TOKEN>`
2. export `HEROKU_EMAIL`
3. export `DATABASE_URL`=`heroku config:get DATABASE_URL --app $APP_NAME`
4. terraform init -backend-config="conn_str=$DATABASE_URL"
5. terraform plan -out plan
6. terraform apply plan

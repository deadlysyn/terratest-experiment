# Getting Started with Terratest

This repo is an example of one way to organize larger
[Terraform](https://www.terraform.io) projects, including using
[Terratest](https://terratest.gruntwork.io) to validte infrastructure
code. It deploys a simple [ECS](https://aws.amazon.com/ecs)-based web
service for the sake of fleshing out associated tests in
[this blog post]().

## Infrastructure Deployment

**NOTE: This project assumes you have
[aws-vault](https://github.com/99designs/aws-vault) installed and a
profile called `personal`.**

Major functionality is organized into
[modules](https://github.com/deadlysyn/terratest-experiment/tree/master/modules).
Configure and execute these from
[environments](https://github.com/deadlysyn/terratest-experiment/tree/master/environments)
sub-directories:

```console
cd projects/dev
make check
make init
make plan
make apply
make destroy
```

To provisioin a new environment, simply copy an existing sub-directory,
rename tfvars, and customize as needed.

## App Deployment

App deployment requires a running Docker daemon to build the image,
and a populated environment directory to consume tfstate.

```console
cd build
./deploy.sh ${environment}
```

## Testing

We use [Terratest](https://terratest.gruntwork.io). You need to have Go installed and configured.

```console
$ cd test
$ make test
```

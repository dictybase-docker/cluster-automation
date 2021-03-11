# GCS bucket
Create a GCS bucket through terraform. The purpose of this terraform setup to
create a bucket that will be used for storing remote state for other terraform
runs.
## Prerequisites
### Install terraform
From [here](https://www.terraform.io/downloads.html)
### Learn terraform
From [here](https://learn.hashicorp.com/terraform). 
### Learn features of GCP
* IAM,role and permissions from [here](https://cloud.google.com/iam/docs/overview). 
* Service accounts from [here](https://cloud.google.com/iam/docs/service-accounts).
### Service account for running terraform 
* Create a GCP `service account`.
* The service account should have the following iam roles/permissions.
```
	storage.buckets.create
```
* Download the json formatted service account key to this current folder and
  rename it to `credentials.json`. In case the key file has a different name or
  resides in a different path, it can be set through `service_account_file`
  terraform variable. This credentials will be used by terraform to
  create the cluster.
## Create bucket
### Setting variables
* All the variables are defined in the `vars.tf` file.
* __Required:__ `project_id`. 
* __Required:__ `bucket_name`. 
* __Optional:__ Read rest of the variables from `vars.tf` file. If not set, their
  default values will be used.
### Running terraform
* `terraform fmt` - To format the files, optional. 
* `terraform init` - Install dependencies, needed to run only one time after
  checking out this repo.
* `terraform plan -var project_id=<value> -var bucket_name=<value>` - Make
  sure to verify the output of the plan. A var file can be used instead of
  command line arguments.
* `terraform apply -var project_id=<value> -var bucket_name=<value>` - To
  create the resources. A var file can be used instead of command line
  arguments.
* __Optional:__ Instead of command line arguments, `terraform plan` and
  `terraform apply` can also be run by providing all the variable values in a
  text file. In that case it is recommended to provide all values in
  `terraform.tfvars` file as it is automatically loade by terraform.
* `terraform destory` - Obvious, isn't it.

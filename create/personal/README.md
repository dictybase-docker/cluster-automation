# Provision a GKE Cluster for personal use 
The GKE cluster is expected to be use by a single developer and therefore the __terraform state__
is not expected to be shared.
## Prerequisites
### Install terraform.
### Learn terraform
### Learn IAM,role,permissions and service accounts from GCP's documentation.
### Service account for running terraform 
* Create a GCP `service account`.
* The service account should have the following iam roles/permissions.
```
    compute.disks.create
    compute.disks.delete
    compute.disks.get
    compute.firewalls.create
    compute.firewalls.delete
    compute.firewalls.get
    compute.firewalls.list
    compute.firewalls.update
    compute.instanceGroupManagers.get
    compute.instances.create
    compute.instances.delete
    compute.instances.get
    compute.instances.setMetadata
    compute.instances.setTags
    compute.machineTypes.get
    compute.networks.create
    compute.networks.delete
    compute.networks.get
    compute.networks.updatePolicy
    compute.subnetworks.create
    compute.subnetworks.delete
    compute.subnetworks.get
    compute.subnetworks.setPrivateIpGoogleAccess
    compute.subnetworks.update
    compute.subnetworks.use
    compute.subnetworks.useExternalIp
    compute.zones.get
    container.clusters.create
    container.clusters.delete
    container.clusters.get
    container.clusters.list
    container.clusters.update
    iam.serviceAccounts.actAs
    iam.serviceAccounts.get
    iam.serviceAccounts.list
    resourcemanager.projects.get
```
* Download the json formatted service account key to this current folder and
  rename it to `credentials.json`. In case the key file has a different name or
  resides in a different path, it can be set through `service_account_file`
  terraform variable. This credentials will be used by terraform to
  create the cluster.
### Service account to be used by node VMs
* Create another GCP `service account`.
* The service account should have the following iam roles/permissions.
```
	monitoring.viewer
	monitoring.metricWriter
	logging.logWriter
	stackdriver.resourceMetadata.writer
        compute.diskTypes.get
        compute.disks.create
        compute.disks.delete
        compute.disks.get
        compute.disks.list
        compute.disks.resize
        compute.disks.update
        compute.disks.use
        compute.regions.get
	storage.buckets.create
    	storage.buckets.delete
    	storage.buckets.get
    	storage.buckets.list
    	storage.buckets.update
    	storage.objects.create
    	storage.objects.delete
    	storage.objects.get
    	storage.objects.list
    	storage.objects.update
```
* Pass this service account name to `service account` variable.
* No service account key need to be downloaded.
## Create cluster
### Setting variables
* All the variables are defined in the `vars.tf` file.
* __Required:__ `project_id` and `service_account` variables needs to be set.  
* __Optional:__ Read rest of the variables from `vars.tf` file. If not set, their
  default values will be used.
* __Optional:__ The default values of mininum cpu and memory resources comes from the default
  `machine_type` value.  So, their default values have to be set based on
  `machine_type` value. The `resource_multiplier` controls the maximum values
  of cpu, memory and node number.
### Running terraform
* `terraform fmt` - To format the files, optional. 
* `terraform init` - Install dependencies, needed to run only one time after
  checking out this repo.
* `terraform plan -var project_id=<value> -var service_account=<value>` - Make
  sure to verify the output of the plan. A var file can be used instead of
  command line arguments.
* `terraform apply -var project_id=<value> -var service_account=<value>` - To
  create the resources. A var file can be used instead of command line
  arguments.
* `terraform destory` - Obvious, isn't it.


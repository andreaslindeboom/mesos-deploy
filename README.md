# Mesos-Deploy
[WIP] A set of Packer builders and Terraform configuration to build and deploy a Mesos cluster. Includes Docker builders with limited functionality for testing purposes.

##Building the image
###Preparation
If you intend to create DigitalOcean snapshots, copy `packer/secrets.json.dist` to `secrets.json,` and enter your DigitalOcean access token.

If you intend to create Docker images, make sure that you have Docker installed locally or spin up a [Docker Machine](https://www.docker.com/docker-machine).

###DigitalOcean Snapshots
Wrapper scripts are included to build master and slave snapshots on DigitalOcean. To build the snapshots, run the following from the project root directory:
####Mesos master
```
packer/build/master.sh
```
####Mesos slave
```
packer/build/slave.sh
```
Note that this script will write out the created snapshot ids to `.mesos-master.snapshot_id` or `.mesos-slave.snapshot_id` to be fed into Terraform later. For this reason, Packer will be run with the `--machine-readable` flag.

###Docker Images
####Mesos master
```
packer build --only=docker -var-file=packer/secrets.json packer/mesos-master.json
```
####Mesos slave
```
packer build --only=docker -var-file=packer/secrets.json packer/mesos-slave.json
```
Note that running these containers will not automatically start Mesos.

##Provisioning to DigitalOcean
###Preparations
Copy `terraform/secrets.tf.dist` to `terraform/secrets.tf` and enter your DigitalOcean access token.

Also, copy `terraform/ssh_key.tf.dist` to `terraform/ssh_key.tf` and enter a unique name for your SSH key, as well as the paths to your private and public key. (the private key will only be used by SSH for remote provisioning)
The same SSH key can not already be present on your DigitalOcean account unless it is being managed by Terraform, or provisioning will fail.

###Preview or execute provisioning
To preview what Terraform would do, run `terraform plan` from the `terraform` directory.

To provision the nodes, run `terraform apply` from the `terraform` directory.

This will provision a single master and a single slave. To preview/provision multiple slaves, pass a number of slaves to Terraform through the `slaves` variable: `terraform plan/apply -var slaves=2`.

Note that valid DigitalOcean snapshot ids from the Packer build step are expected to be present in the following files in the project root: `.mesos-master.snapshot_id` and `.mesos-slave.snapshot_id`.

After provisioning, run `terraform show` to get the IP addresses of the newly created instances.

##Troubleshooting
###The Docker builder hangs at shell script provisioning (OS X)
Boot2Docker and/or Docker Machine are likely unable to reach the directory set as TMPDIR seeing as it is not mounted by default.

A possible workaround would be to set the TMPDIR environment variable to somewhere in your /Users directory:
```
mkdir /Users/username/tmp && TMPDIR=/Users/username/tmp
```

###Provisioning fails because ‘SSH Key is already in use on your account’
This can be remediated by deleting the SSH key from your DigitalOcean account. Terraform will then add it and it will become a Terraform managed resource.

###Provisioning fails because of ‘unprocessable_entity: You specified an invalid image for Droplet creation’
One or both snapshot ids of the master or slave are either not present or the snapshot does not exist in your Terraform account or zone.

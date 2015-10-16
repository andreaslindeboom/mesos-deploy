# Mesos-Deploy
[WIP] A set of Packer builders and Terraform configuration to build and deploy a Mesos cluster. Includes Docker builders with limited functionality for testing purposes.

##Building the image
###Preparation
If you intend to create DigitalOcean snapshots, copy `packer/secrets.json.dist` to `secrets.json,` and enter your DigitalOcean access token.

If you intend to create Docker images, make sure that you have Docker installed locally or spin up a [Docker Machine](https://www.docker.com/docker-machine).

###DigitalOcean Snapshot
From the project root directory:
```
packer/build.sh
```
Note that this script will write out the created snapshot id to `mesos-master.snapshot_id` to be fed into Terraform later. For this reason, Packer will be run with the --machine-readable flag.

###Docker Image
```
packer build --only=docker -var-file=packer/secrets.json packer/mesos-master.json
```
Note that running this container will not automatically start Mesos.

##Provisioning to DigitalOcean
NOTE: this only provisions a Mesos master node for now.

Copy `terraform/secrets.tf.dist` to `terraform/secrets.tf` and enter your DigitalOcean access token.

Also, copy `terraform/ssh_key.tf.dist` to `terraform/ssh_key.tf` and enter a unique name for your SSH key.
The same SSH key can not already be present on your DigitalOcean account unless it is being managed by Terraform, or provisioning will fail.

Then, from the project root directory, run `terraform/provision.sh`.

Note that a valid DigitalOcean snapshot id from the Packer build step is expected to be present in `mesos-master.snapshot_id`.

After provisioning, run `terraform show` to get the IP of the newly created instance.

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
The snapshot id in `.mesos-master.snapshot_id` is either not present or the snapshot does not exist in your Terraform account or zone.

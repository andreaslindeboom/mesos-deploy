terraform plan \
    -var "digitalocean.mesos-master.snapshot_id=$(cat .mesos-master.snapshot_id)" \
    -var "digitalocean.mesos-slave.snapshot_id=$(cat .mesos-slave.snapshot_id)" \
    terraform

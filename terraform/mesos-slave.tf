resource "digitalocean_droplet" "mesos-slave" {
    image = "${var.digitalocean.mesos-slave.snapshot_id}"
    name = "mesos-slave"
    region = "ams3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.mesos-master.id}"]
}

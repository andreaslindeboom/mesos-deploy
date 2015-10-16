resource "digitalocean_droplet" "mesos-master" {
    image = "${var.digitalocean.mesos-master.snapshot_id}"
    name = "mesos-master"
    region = "ams3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.mesos.id}"]
}

provider "digitalocean" {
    token = "${var.digitalocean.access_token}"
}

resource "digitalocean_ssh_key" "mesos-master" {
    name = "${var.ssh_key.name}"
    public_key = "${file(var.ssh_key.path)}"
}

resource "digitalocean_droplet" "mesos-master" {
    image = "${var.digitalocean.snapshot_id}"
    name = "mesos-master"
    region = "ams3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.mesos-master.id}"]
}

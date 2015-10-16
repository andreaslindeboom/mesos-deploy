provider "digitalocean" {
    token = "${var.digitalocean.access_token}"
}

resource "digitalocean_ssh_key" "mesos" {
    name = "${var.ssh_key.name}"
    public_key = "${file(var.ssh_key.path)}"
}


resource "digitalocean_droplet" "mesos-master" {
    image = "${file("../.mesos-master.snapshot_id")}"
    name = "mesos-master"
    region = "ams3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.mesos.id}"]
    private_networking = true
    provisioner "remote-exec" {
        inline = [
            "echo ${digitalocean_droplet.mesos-master.ipv4_address_private} | tee /etc/mesos-master/ip",
            "cp /etc/mesos-master/ip /etc/mesos-master/hostname",
            "sed -i 's/localhost/${digitalocean_droplet.mesos-master.ipv4_address_private}/' /etc/mesos/zk",
            "service mesos-master restart"
        ]
        connection {
            key_file = "${var.ssh_key.private_key_path}"
        }
    }
}

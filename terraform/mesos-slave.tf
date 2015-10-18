resource "digitalocean_droplet" "mesos-slave" {
    image = "${file("../.mesos-slave.snapshot_id")}"
    name = "mesos-slave"
    count = "${var.slaves}"
    region = "ams3"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.mesos.id}"]
    private_networking = true
    provisioner "remote-exec" {
        inline = [
            "echo ${self.ipv4_address_private} | tee /etc/mesos-slave/ip",
            "cp /etc/mesos-slave/ip /etc/mesos-slave/hostname",
            "sed -i 's/localhost/${digitalocean_droplet.mesos-master.ipv4_address_private}/' /etc/mesos/zk",
            "systemctl restart mesos-slave"
        ]
        connection {
            key_file = "${var.ssh_key.private_key_path}"
        }
    }
}

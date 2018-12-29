resource "digitalocean_droplet" "web2" {
  image = "ubuntu-16-04-x64"
  name = "web2"
  region ="lon1"
  size   = "s-1vcpu-1gb"
  private_networking = true
  user_data = "${file("config/webuserdata.sh")}"
  ssh_keys = [
      "${var.ssh_fingerprint}"
  ]
  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }
}



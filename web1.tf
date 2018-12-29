resource "digitalocean_droplet" "web1" {
  image = "ubuntu-16-04-x64"
  name = "web1"
  region ="lon1"
  size   = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
      "${var.ssh_fingerprint}"
  ]
  connection {
      user = "root"
      type = "ssh"
      private_ket = "${file(var.pvt_key)}"
      timeout = "2m"
  }
  provider "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install nginx"     
    ]
  }  
}



resource "digitalocean_domain" "default" {
  name = "kalli.app"
}

resource "digitalocean_record" "terraform" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "terraform"
  value  = "${digitalocean_droplet.haproxy-web.ipv4_address}"
}

resource "digitalocean_droplet" "haproxy-web" {
  image = "ubuntu-16-04-x64"
  name = "haproxy-web"
  region ="lon1"
  size   = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
  provisioner "file" {
    source      = "config/haproxyuserdata.sh"
    destination = "/tmp/haproxyuserdata.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 25",
      "apt-get update",
      "apt-get -y install haproxy"
    ]
  }
  provisioner "file" {
    content     = "${data.template_file.haproxyconf.rendered}"
    destination = "/etc/haproxy/haproxy.cfg"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/haproxyuserdata.sh",
      /* "/tmp/haproxyuserdata.sh",
      "service haproxy restart" */
    ]
  }
}

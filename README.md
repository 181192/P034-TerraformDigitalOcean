# P034-TerraformDigitalOcean

## Terraform - Infrastructure as code
[Terraform](https://www.terraform.io/) enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.

This project is a small example of deploying two web applications and a load balancer using Terraform on [DigitalOcean](https://www.digitalocean.com/).

The result of the application is that each web service is returning the `hostname` and the public IP address of the droplet.

```
$ curl -s http://104.248.173.123/?[1-10]

Droplet: web2, IP Address: 104.248.163.3
Droplet: web1, IP Address: 104.248.171.220
Droplet: web2, IP Address: 104.248.163.3
Droplet: web1, IP Address: 104.248.171.220
Droplet: web2, IP Address: 104.248.163.3
Droplet: web1, IP Address: 104.248.171.220
Droplet: web2, IP Address: 104.248.163.3
Droplet: web1, IP Address: 104.248.171.220
Droplet: web2, IP Address: 104.248.163.3
Droplet: web1, IP Address: 104.248.171.220
```

## Setup the plan
```
terraform.exe plan `
-var "do_token=$DO_TOKEN" `
-var "pub_key=C:\Users\kalli\.ssh\id_digitalocean.pub" `
-var "pvt_key=C:\Users\kalli\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"
```

## Apply and deploy the plan
```
terraform.exe apply `
-var "do_token=$DO_TOKEN" `
-var "pub_key=C:\Users\kalli\.ssh\id_digitalocean.pub" `
-var "pvt_key=C:\Users\kalli\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"
```

## Digital Ocean droplets

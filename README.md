# P034-TerraformDigitalOcean

## Terraform - Infrastructure as code
[Terraform](https://www.terraform.io/) enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.

This project is a small example of deploying two web applications and a load balancer using Terraform on [DigitalOcean](https://www.digitalocean.com/). And also adding a `A record` to the DNS settings such that the loadbalancer is accessable at [terraform.kalli.app](https://terraform.kalli.app)

The result of the application is that each web service is returning the `hostname` and the public IP address of the droplet.

```
$ curl -s http://terraform.kalli.app/?[1-10]

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

## Setup
- [DigitalOcean Account](https://www.digitalocean.com/)
- [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [How to Add SSH Keys to Droplets](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/)
- [How to Upload SSH Public Keys to a DigitalOcean Account](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/to-account/)
- [How to Create a Personal Access Token](https://www.digitalocean.com/docs/api/create-personal-access-token/)

Export the DigitalOcean Personal Access Token and SSH Fingerprint to the console. Replace the values with your own.
```
# Windows
$DO_TOKEN=90514843d8eb4bab17....d246f5desd23ffwe
$SSH_FINGERPRINT=39:fb:3e:d2:df:09:4a:....:90:b7

# Linux
DO_TOKEN=90514843d8eb4bab17....d246f5desd23ffwe
SSH_FINGERPRINT=39:fb:3e:d2:df:09:4a:....:90:b7
```

## Setup the plan
```
# Windows
terraform.exe plan `
-var "do_token=$DO_TOKEN" `
-var "pub_key=$HOME\.ssh\id_digitalocean.pub" `
-var "pvt_key=$HOME\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"

# Linux
terraform plan \
-var "do_token=$DO_TOKEN" \
-var "pub_key=$HOME\.ssh\id_digitalocean.pub" \
-var "pvt_key=$HOME\.ssh\id_digitalocean" \
-var "ssh_fingerprint=$SSH_FINGERPRINT"
```

## Apply and deploy the plan
```
# Windows
terraform.exe apply `
-var "do_token=$DO_TOKEN" `
-var "pub_key=$HOME\.ssh\id_digitalocean.pub" `
-var "pvt_key=$HOME\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"

# Linux
terraform apply \
-var "do_token=$DO_TOKEN" \
-var "pub_key=$HOME\.ssh\id_digitalocean.pub" \
-var "pvt_key=$HOME\.ssh\id_digitalocean" \
-var "ssh_fingerprint=$SSH_FINGERPRINT"
```

## Destroy the plan
```
# Windows
terraform.exe destroy `
-var "do_token=$DO_TOKEN" `
-var "pub_key=$HOME\.ssh\id_digitalocean.pub" `
-var "pvt_key=$HOME\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"

# Linux
terraform destroy \
-var "do_token=$DO_TOKEN" \
-var "pub_key=$HOME\.ssh\id_digitalocean.pub" \
-var "pvt_key=$HOME\.ssh\id_digitalocean" \
-var "ssh_fingerprint=$SSH_FINGERPRINT"
```
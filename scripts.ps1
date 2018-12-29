
terraform.exe plan `
-var "do_token=$DO_TOKEN" `
-var "pub_key=C:\Users\kalli\.ssh\id_digitalocean.pub" `
-var "pvt_key=C:\Users\kalli\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"

terraform.exe apply `
-var "do_token=$DO_TOKEN" `
-var "pub_key=C:\Users\kalli\.ssh\id_digitalocean.pub" `
-var "pvt_key=C:\Users\kalli\.ssh\id_digitalocean" `
-var "ssh_fingerprint=$SSH_FINGERPRINT"


Write-Output `
"FINGERPRINT: `
$SSH_FINGERPRINT`

DO_TOKEN: `
$DO_TOKEN"

# aws_sentry

**Example of sentry deploy on ec2 instance with terraform, using SSL and adding route53 record.**

## how to

1. Create self-signed certificate and upload it to Certificate manager
2. Specify a region in _providers.tf_ file
3. Specify variables in _variables.tf_ file (replacing defaults will work)
4. Make sure _init-script.sh_ is located in the same directory as terraform files
5. Launch terraform

## how it works

Terraform will create an EC2 instance, Load Balancer and Target group for it, security groups. The Load Balancer will be set to SSL usage, so Sentry will be available via HTTPS only. Additionally, Route53 A record will be created and linked to the load balancer.
***Note that all the security groups allow traffic from all over the world!***

Use [this instruction](https://forum.sentry.io/t/default-username-password/13246) to create a user.

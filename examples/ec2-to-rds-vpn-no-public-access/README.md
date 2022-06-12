# Running CloudQuery on an EC2 instance without public access (offline mode)

Based on https://dev.to/rolfstreefkerk/how-to-setup-a-basic-vpc-with-ec2-and-rds-using-terraform-3jij

Architecture:
- EC2 instance in a VPC (no Internet access) with `cloudquery` binary
- RDS instance in a VPC with open access to the EC2 instance


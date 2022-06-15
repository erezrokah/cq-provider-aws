module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.prefix}-postgresql-security-group"
  description = "Complete PostgreSQL example security group"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["postgresql-tcp", "ssh-tcp"]
  egress_rules        = ["postgresql-tcp", "ssh-tcp"]
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.prefix}-postgresql-db"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 40

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "completePostgresql"
  username = "complete_postgresql"
  port     = 5432

  multi_az               = false
  vpc_security_group_ids = [module.rds_security_group.security_group_id]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  availability_zone = "us-east-1d"

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}

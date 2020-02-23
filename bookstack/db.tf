resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.2"
  instance_class       = "db.t2.micro" # Free
  name                 = var.prefix
  username             = var.prefix
  password             = random_password.password.result
  parameter_group_name = "default.mariadb10.2"
}

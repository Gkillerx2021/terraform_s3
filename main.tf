# Recurso para criar um security group
resource "aws_security_group" "Securitygroup-teste" {
  name_prefix = "${var.security_group_name}-"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Recurso para criar uma chave
resource "aws_key_pair" "KeyPair-teste" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLlDmdWKEGVSbHqbsWIrjijMU75nJu54apJUnIwKZ/5grLQJ63KaG2xq7PHgdp4zOBmk3rLk54EL9J/EDNFeb1gI70ej+m8iA8MkM+qRs1gvW5SnrtQJndjpboizhBqpCCmtr1fOwviEye7W9ocaiPP9lrRbBdqzFUN/+krKV7TM+xD1bMDRz4f6ww5yw/cIry4KhvyGsw8plyrWVr8hAwerp8B/XS3JGSHYbLUkC2XY5AKdvNopMFZ9KMqhdmwzufKdqjPYp/gs4iuLlZk0zBQBIjJfhVbZDSlLRugDjWfi3vrtPyXvx6ggdpmrZwOAIYoHndYdyoM5AZiFoRY9i7"
}

# Recurso para criar uma instância EC2
resource "aws_instance" "WinServer-teste" {
  ami             = "ami-00a4f36eef6a4a7d9" # ID da imagem do Windows Server 2016
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.KeyPair-teste.key_name
  security_groups = [aws_security_group.Securitygroup-teste.name]
  subnet_id       = "subnet-0f18150604dcd8db8"
  vpc_id          = "vpc-01463f7636eb62e2f"
  
  tags = {
    Name = var.instance_name
  }
}

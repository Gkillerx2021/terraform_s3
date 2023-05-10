# Definindo o provedor AWS e as credenciais
provider "aws" {
  region     = "us-west-1"
}

# Variável para o nome da instância EC2
variable "instance_name" {
  default = "my-ec2-instance"
}

# Variável para o nome do security group
variable "security_group_name" {
  default = "my-security-group"
}

# Variável para o nome da chave
variable "key_name" {
  default = "my-key-pair"
}

# Recurso para criar um security group
resource "aws_security_group" "my_security_group" {
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
resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

# Recurso para criar uma instância EC2
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-00a4f36eef6a4a7d9" # ID da imagem do Windows Server 2016
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.my_security_group.name]

  tags = {
    Name = var.instance_name
  }
}

# Recurso para enviar o arquivo de output do Terraform para o bucket S3
resource "aws_s3_bucket_object" "terraform_output" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "terraform-output-${terraform.workspace}.txt"
  content = <<-EOT
    Instance ID: ${aws_instance.my_ec2_instance.id}
    Instance Private IP: ${aws_instance.my_ec2_instance.private_ip}
    Security Group: ${aws_security_group.my_security_group.id}
    Key Pair: ${aws_key_pair.my_key_pair.id}
  EOT
}

# Output do bucket S3
output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}

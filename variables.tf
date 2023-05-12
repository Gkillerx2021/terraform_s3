# Variável para o nome da instância EC2
variable "instance_name" {
  default = "WinServer-teste"
}

# Variável para o nome do security group
variable "security_group_name" {
  default = "Securitygroup-teste"
}

# Variável para o nome da chave
variable "key_name" {
  default = "KeyPair-teste"
}

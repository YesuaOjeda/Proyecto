provider "aws" {
region = " "// ingrese la region que desee
access_key = var.miaccesskey
secret_key = var.misecretkey


}
// Crear grupo de seguridad dependiendo el tipo de reglas(ingrese el nombre que quiere para su grupo de seguridad)
resource "aws_security_group" "sgvisual " {
   name = "sgvisual "// Para ingresar el nombre del grupo de seguridad(el mismo que ingreso arriba)
ingress  {
     cidr_blocks = [ "0.0.0.0/0" ]
      description = "Reglas para permitir acceso a http(ipv4)"
      from_port = 80
      protocol = "tcp"
      to_port = 80
    } 
    ingress  {
      ipv6_cidr_blocks = [ "::/0" ]
      description = "Reglas para permitir acceso a http(ipv6)"
      from_port = 80
      protocol = "tcp"
      to_port = 80
    } 
ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Regla para permitir acceso por SSH puerto 22(ipv4)"
    from_port = 22
    protocol = "tcp"
    to_port = 22

}
ingress   {
  ipv6_cidr_blocks = [ "::/0" ]
  description = "Regla para permitir acceso por SSH puerto 22(ipv6)"
  from_port = 22
  protocol = "tcp"
  to_port = 22
} 
ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Reglas para permitir acceso a HTTPS puerto 443(ipv4)"
      from_port = 443
      protocol = "tcp"
      to_port = 443
    } 
    ingress   {
  ipv6_cidr_blocks = [ "::/0" ]
  description = "Regla para permitir acceso por HTTPS puerto 443 (ipv6)"
  from_port = 443
  protocol = "tcp"
  to_port = 443
}

    egress   {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Regla para permitir salida a todo mundo"
      from_port= 0
      protocol = "-1"     
      to_port = 0
    } 
}
resource "aws_instance" " TallerSO"{ //ingresar el nombre de la maquina virtual(instancia)
ami = "  ami-0b28dfc7adc325ef4" // ingresar el ID de ami de la maquina o el 
instance_type = "t2.micro" // Ingresar el tipo de instancia
key_name = "tallerso"// nombre de la clave creada .pem ó .ppk
 vpc_security_group_ids = [aws_security_group.sgvisual.id] // ingresar el nombre del grupo de seguridad

connection {
    
    type        = "ssh"   //este es para el tipo de coneccion o la terminal que usara

    host        = self.public_ip    // aqui ira la tipo de ip ya sea publica o privada

    user        = "ec2-user" // nombre de usuario en este caso asi debe ir

    private_key = file ("C:\\Users\\kevin\\tallerso\\tallerso.pem") // esta es la ruta donde se ingreso la clave creada la .pem ó.ppk
  
  }
  //programas que se instalaran pero aqui iran unos prederminados
   provisioner "remote-exec" {
     inline=[

        "sudo yum -y install  nginx",
        "sudo systemctl start nginx", 
        "sudo yum install awscli -y"
     ]
   }
}
output "ippublica" {
  value = aws_instance.tallerso.public_ip

}
resource "random_integer" "Random" {
  min = 1
  max = 5
}
locals {
   TallerSO = "${var.TallerSO}-${random_integer.random.result}"
}

//este es un bucket prederminado que creara un bucket llamado TallerSO-S3
resource "aws_s3_bucket" "b1" {

  bucket = "TallerSO-S3"

  acl    = "public"   // este sera publico o privado 

  tags = {

    Name        = "Proyecto"

    Environment = "Dev"

  }
resource "aws_s3_bucket_object" "object" {

  bucket = aws_s3_bucket.b1.id

  key    = "PaginaFinal"// Este sera el nombre del objeto creado

  acl    = "public"  // este sera publico o privado

  source = "C:\\Users\\kevin\\tallerso\\Zona_(B).tf"

  etag = filemd5("C:\\Users\\kevin\\tallerso\\Zona_(B).tf")


}
}

    resource "random_integer" "Random" {
  min = 1
  max = 6
}
locals {
   TallerSO-S3 = "${var.TallerSO-S3}-${random_integer.random.result}"

}
resource "random_integer" "Random" {
  min = 1
  max = 6
}
locals {
   PaginaFinal = "${var.PaginaFinal}-${random_integer.random.result}"

}



 
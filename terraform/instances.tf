# fetch lastest OS image ami
data "aws_ami" "lastest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

# output os ami id
output "aws_linux_ami_id" {
    value = data.aws_ami.lastest-amazon-linux-image.id
}

# create ec2 instance for jenkins
resource "aws_instance" "jenkins-server" {
    ami = data.aws_ami.lastest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.mylab-subnet-1.id
    vpc_security_group_ids = [aws_security_group.mylab-sg.id, aws_security_group.jenkins-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "MyKeyPair"
    

    tags = {
        Name = "${var.env_prefix}-jenkins-server"
    }
}

# create ec2 instance for nexus
resource "aws_instance" "nexus-server" {
    ami = data.aws_ami.lastest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.mylab-subnet-1.id
    vpc_security_group_ids = [aws_security_group.mylab-sg.id, aws_security_group.nexus-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "MyKeyPair"
    

    tags = {
        Name = "${var.env_prefix}-nexus-server"
    }
}

resource "null_resource" "configure-jenkins-server" {
    triggers = {
      "trigger" = "aws_instance.jenkins-server.public_ip"
    }

    provisioner "local-exec" {
        working_dir = "../ansible"
        command = "ansible-playbook --inventory ${aws_instance.jenkins-server.public_ip}, --private-key ${var.ssh_private_key} --user ec2-user deploy-jenkins.yaml"
    }    
}

resource "null_resource" "configure-nexus-server" {
    triggers = {
      "trigger" = "aws_instance.nexus-server.public_ip"
    }

    provisioner "local-exec" {
        working_dir = "../ansible"
        command = "ansible-playbook --inventory ${aws_instance.nexus-server.public_ip}, --private-key ${var.ssh_private_key} --user ec2-user deploy-nexus.yaml"
    }    
}

# output ec2 instence public ip to ssh
output "jenkins_public_ip" {
    value = aws_instance.jenkins-server.public_ip
}

output "nexus_public_ip" {
    value = aws_instance.nexus-server.public_ip
}


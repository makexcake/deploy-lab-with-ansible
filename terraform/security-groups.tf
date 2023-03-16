resource "aws_security_group" "mylab-sg" {
    name = "mylab-sg"
    vpc_id = aws_vpc.mylab-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

resource "aws_security_group" "jenkins-sg" {
    name = "jenkins-sg"
    vpc_id = aws_vpc.mylab-vpc.id

    ingress {
        from_port = 0
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 50000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

resource "aws_security_group" "nexus-sg" {
    name = "nexus-sg"
    vpc_id = aws_vpc.mylab-vpc.id

    ingress {
        from_port = 0
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}




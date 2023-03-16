# deploy-lab-with-ansible

Showcase project, sets up a lab with Jenkins and Nexus running on AWS EC2 instances provisioned with Terraform.

## Installation

Ansible machine must have python 3, Terraform and Ansible installed with the python packages in the requirements.txt file. Also AWS account must be configured on the local machine.

Install python packages with the following command:

```bash
pip3 install -r requirements.txt
```

## Usage

* Login into AWS account on the Ansible server.
* In the terraform folder execute the following command:
```bash
$ cd terraform
$ terraform init
$ terraform apply
```

The script will provision an EC2 instances, afterwards will deploy Jenkins and Nexus containers on the instances.


## Contributing

Tweaks, tricks and suggestions will be gladly appriciated.

#!/bin/bash
sshpass -p ubuntu ssh ubuntu@192.168.1.13 'sh /tmp/destroy_terraform.sh'
cd terraform
cd 01_natgw
terraform destroy --auto-approve --var-file="natgw.tfvars"


# test
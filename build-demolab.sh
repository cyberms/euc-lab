#!/bin/bash

#################################
# Ansible for vCenterdeployment #
#################################
cd ansible
ansible-playbook -i inventory.yml deploy-vcenter.yml
cd ..

##########
# Packer #
##########

cd packer

# # Install Ubuntu 20.04 Template
# cd ubuntu_server_20.04
# packer init ubuntu_server_20.04.pkr.hcl
# packer build -var-file ubuntu_server_20.04.pkrvars.hcl -var-file vsphere.pkrvars.hcl ubuntu_server_20.04.pkr.hcl
# cd ..

# # #Install Windows Server 2019 Template
# cd windows_server_19
# packer init windows_server_19.pkr.hcl
# packer build -var-file windows_server_19.pkrvars.hcl -var-file vsphere.pkrvars.hcl windows_server_19.pkr.hcl
# cd ..

# # Install Windows Server 2022 Template
cd  windows_server_22
packer init windows_server_22.pkr.hcl
packer build -var-file windows_server_22.pkrvars.hcl -var-file vsphere.pkrvars.hcl windows_server_22.pkr.hcl
cd .. 

# # Install Windows Client 2111 Template
cd windows_client_2111
packer init windows_client_2111.pkr.hcl
packer build -var-file windows_client_2111.pkrvars.hcl -var-file vsphere.pkrvars.hcl windows_client_2111.pkr.hcl
cd ..

# # Install Windows Client 21H2 Template
cd windows_client_21H2
packer init windows_client_21H2.pkr.hcl
packer build -var-file windows_client_21H2.pkrvars.hcl -var-file vsphere.pkrvars.hcl windows_client_21H2.pkr.hcl
cd ..
cd ..

#############
# Terraform #
#############
cd terraform
cd ctxlab
terraform init
terraform plan -target=module.natgw
terraform apply --auto-approve -target=module.natgw
terraform plan
terraform apply --auto-approve
cd ..
cd ..
###########
# Ansible #
###########

cd ansible
ansible-playbook configure-demolab.yml
cd ..

#Sync
# ansible-playbook --inventory-file=/usr/bin/terraform-inventory ./ansible/playbook.yml -e @./ansible/vars.yml
#If you prefer to run most of the tasks async (can increase resources)
#ansible-playbook --inventory-file=/usr/bin/terraform-inventory ./ansible/playbook-async.yml -e @./ansible/vars.yml
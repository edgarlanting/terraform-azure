# terraform-azure
My collection of terraform related thingies for the Azure platform

- Use the azure_mssql.tf file to roll out a virtual machine with MSSQL 2016 Developer on Windows Server 2016

1. Install Terraform
2. Change the tf file with the info for your Azure credentials and Windows username (and whatever you want to change)
3. Roll out your mini infrastructure

Execute with;

terraform plan -out=plan.out
terraform apply


Documentation will be completed...

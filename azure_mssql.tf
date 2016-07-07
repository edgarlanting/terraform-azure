# Connect to the Azure Provider
provider "azure" {
#settings_file is deprecated, so don't use this! EL 20160707
publish_settings = "${file("<filename>.publishsettings")}"
}

# create a storage account
resource "azure_storage_service" "storage" {
name = "terraformtest"
location = "Central US"
description = "Created with Terraform"
account_type = "Standard_LRS"
}

#create virtual network
resource "azure_virtual_network" "default" {
name = "test-network"
address_space = ["10.1.2.0/24"]
location = "Central US"

subnet {
name = "subnet1"
address_prefix = "10.1.2.0/25"
    }
}

# create windows virtual machine
resource "azure_instance" "windows" {
depends_on = ["azure_virtual_network.default"]
name = "mytf-win-254${count.index}"
image = "SQL Server 2016 Enterprise Windows Server 2012 R2"
size = "Basic_A0"
storage_service_name = "${azure_storage_service.storage.name}"
location = "Central US"
username = "<username>"
password = "<password>"
time_zone = "America/New_York"
virtual_network = "${azure_virtual_network.default.name}"
count = "1"

endpoint {
name = "RDP"
protocol = "tcp"
public_port = 3389
private_port = 3389
    }
}


# IP address outputs

output "azure-windows-vips" {
value = "${join(",", azure_instance.windows.*.name)}:${join(",", azure_instance.windows.*.vip_address)}"
}
output "azure-windows-ips" {
value = "${join(",", azure_instance.windows.*.name)}:${join(",", azure_instance.windows.*.ip_address)}"
}

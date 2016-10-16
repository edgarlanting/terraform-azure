# Connect to the Azure Provider
provider "azure" {
publish_settings = "${file("your-azure-credentials.publishsettings")}"
}

# Create a storage account
resource "azure_storage_service" "storage" {
name = "defaultstor1"
location = "Central US"
description = "Default storage account"
account_type = "Standard_LRS"
}

# Create a virtual network
resource "azure_virtual_network" "default" {
name = "test-network"
address_space = ["10.1.2.0/24"]
location = "Central US"

subnet {
name = "subnet1"
address_prefix = "10.1.2.0/25"
    }
}

# Create a Windows VM with SQL2016
resource "azure_instance" "windows" {
depends_on = ["azure_virtual_network.default"]
name = "mytf-win-254${count.index}"
image = "SQL Server 2016 RTM Developer on Windows Server 2016"
size = "Basic_A1"
storage_service_name = "${azure_storage_service.storage.name}"
location = "Central US"
username = "pickausername"
password = "Pass!admin123"
time_zone = "Europe/Amsterdam"
virtual_network = "${azure_virtual_network.default.name}"
count = "1"

# Create the endpoint to connect to
endpoint {
name = "RDP"
protocol = "tcp"
public_port = 3389
private_port = 3389
    }
}

# Create IP address outputs

output "azure-windows-vips" {
value = "${join(",", azure_instance.windows.*.name)}:${join(",", azure_instance.windows.*.vip_address)}"
}
output "azure-windows-ips" {
value = "${join(",", azure_instance.windows.*.name)}:${join(",", azure_instance.windows.*.ip_address)}"
}


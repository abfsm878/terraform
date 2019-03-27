resource "azurerm_resource_group" "test" {
  name     = "Terraform-RG"
  location = "Canada Central"
}

resource "azurerm_network_security_group" "test" {
  name                = "NSG1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_ddos_protection_plan" "test" {
  name                = "ddospplan1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_virtual_network" "test" {
  name                = "vNet1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  address_space       = ["192.168.0.0/16"]
  dns_servers         = ["192.168.0.4", "192.168.0.5"]

  ddos_protection_plan {
    id     = "${azurerm_ddos_protection_plan.test.id}"
    enable = true
  }

  subnet {
    name           = "Subscription-Subnet"
    address_prefix = "192.168.1.0/27"
  }

  subnet {
    name           = "Cluster-Subnet"
    address_prefix = "192.168.2.0/27"
  }

  subnet {
    name           = "DMZ-Subnet"
    address_prefix = "192.168.3.0/27"
    security_group = "${azurerm_network_security_group.test.id}"
  }

  tags = {
    environment = "Terraform First Deployment"
  }
}
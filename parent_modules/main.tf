module "rg" {
  source = "../child_modules/azurerm_resource_group"
  rgs = {
    rg1 = {
      name     = "rg-om"
      location = "eastus"
    }
    rg2 = {
      name     = "rg-dia"
      location = "eastus"
    }
  }

}
module "virtual_network" {
  depends_on = [module.rg]
  source     = "../child_modules/azurerm_virtual_network"
  vnets = {
    vnet1 = {
      name                = "nsv7a0ntas0001c"
      location            = "eastus"
      resource_group_name = "rg-ankur"
      address_space       = ["10.12.0.0/16"]
    }

    vnet2 = {
      name                = "nsv7a0ntas0002c"
      location            = "eastus"
      resource_group_name = "rg-ankur"
      address_space       = ["10.13.0.0/16"]
    }
  }
}
module "subnet" {
  depends_on = [module.virtual_network]
  source     = "../child_modules/azurerm_subnet"
  snets = {
    subnet1 = {
      name                 = "frontend-subnet"
      resource_group_name  = "rg-ankur"
      virtual_network_name = "nsv7a0ntas0001c"
      address_prefixes     = ["10.12.1.0/24"]
    }
    subnet2 = {
      name                 = "backend-subnet"
      resource_group_name  = "rg-ankur"
      virtual_network_name = "nsv7a0ntas0002c"
      address_prefixes     = ["10.13.1.0/24"]
    }
  }
}
module "pip" {
    depends_on = [ module.rg ]
  source = "../child_modules/azurerm_public_ip"
  pip = {
    pip1 = {
      name                = "pipnsv7"
      resource_group_name = "rg-ankur"
      location            = "eastus"
      allocation_method   = "Static"
    }
    pip2 = {
      name                = "pipnsv4"
      resource_group_name = "rg-ankur"
      location            = "eastus"
      allocation_method   = "Static"
    }
  }

}
module "vms" {
    depends_on = [ module.subnet,module.pip ]
  source = "../child_modules/azurerm_virtual_machine"
  vms = {
    vm1 = {
      nic_name             = "nic-frontend"
      location             = "eastus"
      resource_group_name  = "rg-ankur"
      subnet_name          = "frontend-subnet"
      virtual_network_name = "nsv7a0ntas0001c"
      pip_name             = "pipnsv7"
      vm_name              = "frontend-vm"
      size                 = "Standard_DC1ds_v3"
      admin_username       = "adminuser"
      admin_password       = "Admin@234"

    }
    vm2 = {
      nic_name             = "nic-backend"
      location             = "eastus"
      resource_group_name  = "rg-ankur"
      subnet_name          = "backend-subnet"
      virtual_network_name = "nsv7a0ntas0002c"
      pip_name             = "pipnsv4"
      vm_name              = "backend-vm"
      size                 = "Standard_DC1ds_v3"
      admin_username       = "adminuser"
      admin_password       = "Admin@234"

    }

  }
}
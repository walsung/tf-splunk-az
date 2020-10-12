variable "resource_group_name" {
  type        = string
  default = "rg-splunk"
  description = "cluster of splunk"
}

variable "location" {
  type        = string
  default = "Japan East"
  description = "The Azure location to use for deployment"
}

variable "login_password" {
  type        = string
  default = "changeme"
  description = "splunk login password: admin:change"
}


locals {
    common_cpu = 1
    common_ram = 2
    sh_cpu = 2
    sh_ram = 2
    idx_cpu = 2
    idx_ram = 2
    webport = 8000
    kvport = 8091
    mgmtport = 8089
    replicationport = 4001
    listenport = 9997
    hecport = 8088
    sshport = 22
}



variable "common_instance" {
    description = "license-master(including deployment server and monitoring console), deployer, masternode"
    type = map
    default = {
        license-master = {
            name = "license-master",
        },
        deployer = {
            name = "deployer",
        },
        masternode = {
            name = "masternode",
        }
    }
}

# variable "shc" {
#     description = "search head clustering"
#     type = object({
#         sh1 = string
#         sh2 = string
#         sh3 = string
#         sh4 = string
#         sh5 = string
#         sh_cpu = number
#         sh_ram = number
#     })
# }

# variable "idxcl" {
#     description = "index clustering"
#     type = object({
#         idx1 = string
#         idx2 = string
#         idx3 = string
#         idx4 = string
#         heavy-forwarder = string 
#         idx_cpu = number
#         idx_ram = number
#     })
# }


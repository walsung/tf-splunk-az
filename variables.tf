


variable "subscription_id" {
  type = string
  description = "Azure subscription id, can be found by command: az account show"
}

variable "tenant_id" {
  type = string
  description = "Azure tenant id, can be found by command: az account show"
}


# variable "resource_group_name" {
#     description = "create 3 resource groups: Japan East, Korea South, UAE North"
#     type = map
#     default = {
#         japan_east = {
#             name = "rg-splunk-jpe",
#             location = "Japan East",
#         },
#         korea_south = {
#             name = "rg-splunk-krs",
#             location = "Korea South",
#         },
#         uae_north = {
#             name = "rg-splunk-uen"
#             location = "UAE North",
#         },
#     }
# }



# variable "resource_group_name" {
#   type        = string
#   default = "rg-splunk"
#   description = "cluster of splunk"
# }

variable "resource_group_name_jp" {
  type        = string
  default = "rg-splunk_jp"
  description = "splunk common components"
}

variable "resource_group_name_kr" {
  type        = string
  default = "rg-splunk_kr"
  description = "splunk search head clustering"
}

variable "resource_group_name_ue" {
  type        = string
  default = "rg-splunk_ue"
  description = "splunk index clustering"
}

variable "location_jpe" {
  type        = string
  default = "Japan East"
  description = "The Azure location to use for deployment"
}

variable "location_krs" {
  type        = string
  default = "Korea South"
  description = "The Azure location to use for deployment"
}

variable "location_uen" {
  type        = string
  default = "UAE North"
  description = "The Azure location to use for deployment"
}


variable "login_password" {
  type        = string
  default = "changeme"
  description = "splunk login password: admin:change"
}

variable "environment" {
  type = string
  default = "testing"
  description = "tag this as Testing Environment"
}

variable "container_name" {
  default = "splunk"
}

variable "docker_image_name" {
  default = "splunk/splunk:latest"
}


locals {
    common_cpu = 2
    common_ram = 2
    sh_cpu = 2
    sh_ram = 2
    idx_cpu = 2
    idx_ram = 2
    webport = 8000
    kvport = 8091
    mgmtport = 8089
    replicationport = 9200
    listenport = 9997
    hecport = 8088
    sshport = 22
    udpport = 514
}



variable "common_instance" {
    description = "license-master(including deployment server and monitoring console), deployer, masternode"
    type = map
    default = {
        license-master = {
            name = "licmast",
        },
        masternode = {
            name = "mastern",
        }
    }
}

variable "heavyforwarder" {
  description = "Heavy Forwarder that does the data striping and receives syslog"
  default = "hvyfwd"
}


variable "searchhead_clustering" {
    description = "search head clustering"
    type = map
    default = {
        deployer = {
            name = "deployer",
        },
        sh1 = {
            name = "search1",
        },
        sh2 = {
            name = "search2",
        },
        sh3 = {
            name = "search3",
        }
        sh4 = {
            name = "search4",
        }
        sh5 = {
            name = "search5",
        }
    }
}

variable "index_clustering" {
    description = "index clustering"
    type = map
    default = {
        idx1 = {
            name = "index1",
        },
        idx2 = {
            name = "index2",
        },
        idx3 = {
            name = "index3",
        },
        idx4 = {
            name = "index4",
        },
    }
}



variable "subscription_id" {
  type = string
  description = "Azure subscription id, can be found by command: az account show"
}

variable "tenant_id" {
  type = string
  description = "Azure tenant id, can be found by command: az account show"
}



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

variable "searchhead_clustering" {
    description = "search head clustering"
    type = map
    default = {
        deployer = {
            name = "deployer",
        },
        sh1 = {
            name = "sh1",
        },
        sh2 = {
            name = "sh2",
        },
        sh3 = {
            name = "sh3",
        }
        sh4 = {
            name = "sh3",
        }
        sh5 = {
            name = "sh5",
        }
    }
}

variable "index_clustering" {
    description = "index clustering"
    type = map
    default = {
        idx1 = {
            name = "idx1",
        },
        idx2 = {
            name = "idx2",
        },
        idx3 = {
            name = "idx3",
        },
        idx4 = {
            name = "idx4",
        },
    }
}

variable "heavyforwarder" {
  description = "Heavy Forwarder that does the data striping and receives syslog"
  default = "hvyfwd"
}


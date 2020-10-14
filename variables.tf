


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
    location_jpe = "Japan East"
    location_shc = "Australia East"
    location_idxc = "North Central US"
    common_cpu = 2
    common_ram = 2
    sh_cpu = 2
    sh_ram = 2
    idx_cpu = 2
    idx_ram = 2
    webport = 8000
    kvport = 8191
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

variable "deployer" {
  description = "exactly same settings as of those search heads, but Azure region has limited of uitilising 10 cores, so destroyer needs to be deployed in a separate region"
  default = "deployer"
}


variable "searchhead_clustering" {
    description = "search head clustering"
    type = map
    default = {
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



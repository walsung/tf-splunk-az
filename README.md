# Proof-of-concept: Set up a Splunk test cluster environment in Azure and demonstrate the vault management via Terraform Cloud

This article covers 2 topics: 
1. Build a Splunk test environment with 13 Azure Container Instances (ACIs) using Terraform
2. Terraform Cloud key management

Main.tf is using Terraform remote backend to managing subscription-id and tenant-id to connect to Azure cloud, therefore you will need to modify the first stanza in main.tf to login Azure.

!!Caveat!!
This is for proof-of-concept of building a simulation of Splunk clustering architecture by creating 13 ACIs (Azure Container Instances) in Azure Infrastructure. All ip addresses are external-facing and using Azure public DNS to resolve ip address, hence DO NOT ingest any sensitive data or production logs into the indexers. 

Each Azure region only allows up to 10 cpus for creating ACI, therefore index clustering and search head clustering are created in separate region. These can be modified by local variable.
location_idxc
location_shc

Below is the architecture diagram where license-master also acts as deployment server and monitoring console
![Screenshot](splunk.png)



Caveat
ACI 
Pros and Cons about building a test environment in Azure ACI
Pros:
Quick and easy to spin up a bunch of containers
Easily destroy the entire environment with command “terraform destroy –auto-approve
All containers have external public ip so that you can demonstrate your architecture plan to your customers, however you may spend extra work to harden the environment with Azure NSG and firewall which aren’t covered in this article. Azure Firewall is actually quite expensive too keep it running all the time. 
Each container can be accessed easily with Azure cloud shell, no need to set up SSH key like AWS does.
Azure real-time log analysis is more intuitive
It’s a pain in the butt to get Terraform Vault working to securely store your IAM keys or Azure keyvaults. Terraform Cloud has an online keyvault feature which is more intuitive to set up and can work across multiple devices because the keys are stored in the cloud. We entrust Terraform Cloud to keep the keys safe. If it were a production environment, it’s highly recommended to set up Terraform Vault and keep your IAM keys on-prem. 

Cons:
Since all ACIs are external facing, do not put production data in the test environment, or you have to sanitize your data before ingesting in
If you want to scale up for more ACIs, edit the Terraform main.rf template to scale up more containers in different Azure regions. Each Azure region only supports up to 10 CPU cores running, and since each container takes 2 cpu cores, maximum 5 ACIs can be run per region. 
Not every region supports container group. For the availability, refer to document: https://docs.microsoft.com/en-us/azure/container-instances/container-instances-region-availability
Each Azure region charges container group per hour differently, I find EAST US 2 sometimes is the cheapest

The sample architecture diagram is a typical SVA M14 (multi-sites and indexer+search head clustering). Terraform template is scalable to fit your test environment by increasing or decreasing the numbers of containers, or even split up more roles of standalone instance. More samples of Splunk validated architecture (SVA) can be refer to document: https://www.splunk.com/pdfs/technical-briefs/splunk-validated-architectures.pdf.
Here’s the opening ports on each ACI

Pre-requisite
    1. You need to register an Azure account. https://portal.azure.com, install Azure CLI locally
    2. You need to register a Terraform Cloud account. https://app.terraform.io/
    3. Azure CLI can be run on local or on cloud shell
    4. Highly recommended to set multi-factor authencation to Azure and Terraform accounts

How to run Terraform template
    1. Install the latest version of Terraform binary. https://www.terraform.io/downloads.html. By the time this article was written, I was using Terraform version 0.13.4
    2. Azurerm version is , more Azure provider commands can be found from https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
    3. Log in Terraform Cloud, create a new Workspace
    4. Make a name for your new Workspace, choose the second option “CLI-driven workflow”
    5. Open main.rf, edit the backend stanza to suit your Terraform Cloud’s organization name and workspace name
terraform {
  backend "remote" {
    organization = "eclipse13"

    workspaces {
      name = "test"
    }
  }
}

    6. Since test environment is disposable and it doesn’t worth the effect to set up Terraform Vault on-prem. Terraform Cloud provides an easy solution to store Azure keys. 

Run xxxx command in 

Go back to Terraform Cloud and open your Workspace, on the menu bar, click on Variables. 
Terraform Variable can replace your local variables.tfvars, that’s where you put in Azure subscription id and tenant id
Environment Variables allows the backend connecting and authenticating with Azure. Run the command and manually type in xxxxxxxxxx    .    Set the key to sensitive so that nobody can read the value even if your Terraform Cloud account is compromised. 



Paramaters



    7. Then can run the commands like ‘terraform init’, ‘terraform plan’, ‘terraform apply’ locally
Enjoy~~~!


![Logo of the project](images/logo.png)

# Tanzify Live Repo

 [Terragrunt](https://terragrunt.gruntwork.io) Modules that install VMware Tanzu Products. This uses terraform modules from https://github.com/abhinavrau/tanzify-infrastructure
 
<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
* [Usage](#usage)
* [License](#license)
* [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project
Using [best practices](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/#promote-immutable-versioned-terraform-modules-across-environments) for using Terraform,
the modules here are currently support installing the following VMware Tanzu products:

| Product | AWS | GCP | Azure | vSphere |
|----|-----|-----|-----|-----|
| Tanzu Application Service (a.k.a PAS) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: |
| Tanzu Kubernetes Grid Integrated (a.k.a PKS) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: |

It also supports installing the following Tiles. 

| Tile | 
|------|
| Harbor Container Registry
| MySQL  |
| RabbitMQ  |
| Redis  |
| Pivotal Cloud Cache |
| Spring Cloud Services 3 |
| Spring Cloud Data Flow  |
| Metrics  |
| Healthwatch  |
| Credhub Service Broker  |
| Pivotal Anti-Virus  |
| Spring Cloud Gateway  |
| SSO |

**Note:** Not all versions of tiles have been tested, so your mileage may vary.  

<!-- GETTING STARTED -->
## Getting Started

This uses terraform modules from https://github.com/abhinavrau/tanzify-infrastructure

More details on why is detailed in the Terragrunt docs [here](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/#promote-immutable-versioned-terraform-modules-across-environments) 
and [here](https://blog.gruntwork.io/5-lessons-learned-from-writing-over-300-000-lines-of-infrastructure-code-36ba7fadeac1)

### Prerequisites

- Terraform 0.13+
- Terragrunt 0.24.0+
- LastPass CLI installed if you are using it as your secret store.


<!-- USAGE EXAMPLES -->
## Usage


* Clone this repo into another directory
```
git clone https://github.com/abhinavrau/tanzify-arau-live.git tanzify-username-live
```
*  This repo has one example each for AWS, Azure and GCP. Keep the directory for the cloud provider you want and remove the others.
Rename the region and `demo1` directories to suit your needs.

* Modify the following files for the cloud provider/region/AZs you are targeting:

```
account.hcl
region.hcl
env.hcl
```

* Secrets:
    - If Using LastPass, install & configure LastPass CLI
    - Store your secrets (Cloud provider credentials, Opsman password and Pivnet token) in LastPass
    - Modify the LastPass item ID in the `.hcl` files under the directory `0_secrets`. Hint: Use `lpass ls | grep itemname ` to find item ID.
    - `export LASTPASS_PASSWORD="~/.lpass"`  and `export LASTPASS_USER="lastpassuserid"`
    - cd `_scripts`
    - run `./0_apply_secrets.sh` to make secrets are being fetched correctly.
    
* Pave Network and Storage:
  -  From`_scripts` directory run `1_apply_infra`
* Install OpsMan
  - Modify `1_opsman-compute/opsman_vars.hcl` to reflect the version and build of Opsman to use.
  - From`_scripts` directory run `2_apply_infra` to install OpsMan and BOSH director
* Install Tiles
  - Modify `1_tkgi-install-configure/tkgi_vars.hcl` to reflect the version of TKGI to install.
  - Modify `2_tas-install-configure/tas4vms_vars.hcl` to reflect the version of TAS to install.
  - Modify `3_harbor-install-configure/harbor_vars.hcl` to reflect the version of Harbor to install.
  - From`_scripts` directory run `3_apply_tiles.sh` to install TAS/TKGI/Harbor
  
  - To Install other tiles, take a look at the `3_harbor-install-configure/terragrunt.hcl` and tile configurations under the terraform module `tanzify-infrastructure/tile-install-configure/configuration`

## Troubeshooting

1. Running `./0_apply_secrets.sh` throwing errors. 
  **Possible Fix:** LastPass CLI may have logged you out. Run `lpass login`
2. Something went wrong with a module and I need to run it again. 
**Possible Fix:** Navigate to the directory with the problem and remove the `.terragrunt-cache` directory which will refecth the module and reset your state. 
  You can run `find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;` to recuresively delete the .terragrunt-cache directories. 

## Cleanup

To delete the installation completely including OpsMan and all Tiles, follow these steps:
1. From`_scripts` directory run `./ssh_opsman.sh` to login to OpsMan
2. Run `destroy_opsman` to delete all tiles including BOSH Director. Run `exit` 
3. Navigate to `2_opsman` directory. Run `terragrunt destroy-all --terragrunt-non-interactive`
4. Navigate to `1_infra` directory. Run `terragrunt destroy-all --terragrunt-non-interactive`

### Cleaning up when you mess up something
If you don't have the previous terragrunt state directories (or deleted them by mistake) and terragrunt can't destroy the resources. you can use [leftovers](https://github.com/genevieve/leftovers)

For GCP run:
`leftovers --iaas=gcp --gcp-service-account-key=path/to/serviceaccount.json --filter=<environment-name>`

For AWS run:
`leftovers --iaas=aws --aws-access-key-id=<..> --aws-secret-access-key=<..> --aws-region=<region>> --filter=<environment-name>`

For Azure run:
`leftovers --iaas=azure --azure-client-id=<...> --azure-client-secret=<..> --azure-tenant-id=<..> --azure-subscription-id=<..> --filter=<environment-name>`

The environment-name is the same as the resource group in Azure.

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information. 

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
This project could not have possible without awesome code from the following repos:

* [paasify-pks](https://github.com/niallthomson/paasify-pks)
* [paasify-pks](https://github.com/niallthomson/paasify-core)
* [pcf-passify](https://github.com/nthomson-pivotal/pcf-paasify)




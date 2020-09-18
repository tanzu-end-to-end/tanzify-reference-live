![Logo of the project](images/logo.png)
#Tanzify Live Repo

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

*Note:* Not all versions of tiles have been tested so your mileage may vary. 

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
  - Modify 1_opsman-compute/opsman_vars.hcl to reflect the version and build of Opsman to use.
  - From`_scripts` directory run `2_apply_infra` to install OpsMan and BOSH director
* Install Tiles
  - Modify 1_tkgi-install-configure/tkgi_vars.hcl to reflect the version of TKGI to install.
  - Modify 2_tas-install-configure/tas4vms_vars.hcl to reflect the version of TAS to install.
  - Modify 3_harbor-install-configure/harbor_vars.hcl to reflect the version of Harbor to install.
  - From`_scripts` directory run `3_apply_tiles.sh` to install TAS/TKGI/Harbor

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information. 

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
This project could not have possible without awesome code from the following repos:

* [paasify-pks](https://github.com/niallthomson/paasify-pks)
* [paasify-pks](https://github.com/niallthomson/paasify-core)
* [pcf-passify](https://github.com/nthomson-pivotal/pcf-paasify)




## Usage

Congratulations!  You now have a K8s platform.  But how do you use it?

### Prerequisites

Download and install suitable OS-variants of the CLIs below:

* [uaa-cli](https://github.com/cloudfoundry-incubator/uaa-cli/releases) 0.10.0 or better
* [tkgi](https://network.pivotal.io/products/pivotal-container-service/) 1.8 or better


### Managing users

#### Create new UAA user and ascribe cluster management privileges

> See https://docs.pivotal.io/tkgi/1-10/manage-users.html for more details.

```bash
uaa-cli uaa-cli target https://{TKGI_API_ENDPOINT}:8443 -k
uaa-cli get-client-credentials-token admin -s {TKGI_UAA_MANAGEMENT_ADMIN_CLIENT_SECRET}
uaa-cli create-user tanzu-gitops --email tanzu-gitops@notreal.com --password {PASSWORD}
uaa-cli add-member pks.clusters.manage tanzu-gitops
```

### Managing clusters

> See https://docs.pivotal.io/tkgi/1-10/manage-index.html for more details.

#### Authenticate

```bash
tkgi login -a {TKGI_API_ENDPOINT} -u tanzu-gitops -p {PASSWORD} -k
```

#### List plans

```bash
tkgi plans
```

#### List clusters

```bash
tkgi clusters
```

#### View cluster details

```bash
tkgi cluster {CLUSTER_NAME}
```

#### Create new cluster

```bash
tkgi create-cluster {CLUSTER_NAME} \
--external-hostname {HOSTNAME} \
--plan {PLAN_NAME)
```

optional arguments

```
--num-nodes {NUMBER_OF_WORKER_NODES} \
--network-profile {NETWORK_PROFILE_NAME} \
--tags {TAGS}
```

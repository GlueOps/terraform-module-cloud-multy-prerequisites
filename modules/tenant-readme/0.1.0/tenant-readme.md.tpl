# placeholder_repo_name

_Welcome to the tenant repository, used to manage a kubernetes deployment with the GlueOps Platform!_

## Overview
This README will outline the steps required to:

1. Create the necessary Accounts/Projects/Credentials to deploy kubernetes.
2. Deploy Kubernetes in the desired cloud. 
3. Deploy the GlueOps Platform (including ArgoCD) on the Kubernetes Cluster.
4. Tear down the cluster when it is no longer needed.

<br /><br />
## Prerequisites (not k3d)

1. User account in the desired cloud with necessary permissions to create Service Users capable of deploying a Kubernetes cluster.
2. [Create a new Codespace.](https://github.com/codespaces/new?hide_repo_select=true&ref=%F0%9F%9A%80%F0%9F%92%8E%F0%9F%99%8C%F0%9F%9A%80&repo=527049979&skip_quickstart=true&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fplaceholder_codespace_version%2Fdevcontainer.json)
3. This repository, `placeholder_repo_name`, cloned into the codespace required above. Once the Codespace is created, the repo can be cloned using 

```sh
gh repo clone placeholder_github_owner/placeholder_repo_name
```

<br /><br />

## Select Cloud
- [GCP](#GCP)
- [AWS](#AWS)
- [k3d](https://github.com/GlueOps/k3d)

## GCP

### Deploy Kubernetes
1. Create Credentials
    * [Launch a CloudShell](https://console.cloud.google.com/home/dashboard?cloudshell=true) within your developer GCP account.
    * Execute the following command in the cloudshell.  Click 'Authorize' if prompted and give the script a minute to finish.
    
    ```sh
    bash <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/placeholder_tools_version/tools/gcp/dev-project.sh)
    ```

    * Create the`.env` as instructed into this repository, within the codespace.


2. Deploy Kubernetes with Terraform
    * Set credentials for Terraform using the `.env` created in step 1a.:

    ```sh
    source $(pwd)/.env
    ```

    * Reference documents for [terraform-module-cloud-gcp-kubernetes-cluster](https://github.com/GlueOps/terraform-module-cloud-gcp-kubernetes-cluster) and use the pre-created directory `terraform/kubernetes` within this repo for the `main.tf` file to deploy the cluster.
    * **At minimum**, the parameter `project_id` must be updated within the `main.tf`

3. To authenticate with the GKE cluster uncomment the line in your `.env` that starts with `gcloud container clusters get-credentials captain` and then run:

    ```sh
    source $(pwd)/.env
    ```

4. Now that Kubernetes is deployed and can be accessed, begin [deploying the GlueOps Platform](#Deploying-GlueOps-the-Platform)


## AWS

### Deploy Kubernetes
1. Create Credentials
    * [Launch a CloudShell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-west-2) within the Primary/Root AWS Account.
    * Execute the following command in the cloudshell.  When prompted, enter the name of your captain account (e.g. glueops-captain-laciudaddelgato).

    ```sh
    bash <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/placeholder_tools_version/tools/aws/account-setup.sh)
    ```

    * Create the`.env` as instructed into this repository, within the codespace.

2. Deploy Kubernetes with Terraform
    * Set credentials for Terraform using the `.env` created in step 1a.:

    ```sh
    source $(pwd)/.env
    ```

    * Reference documents for [terraform-module-cloud-aws-kubernetes-cluster](https://github.com/GlueOps/terraform-module-cloud-aws-kubernetes-cluster) and use the pre-created directory `terraform/kubernetes` within this repo for the `main.tf` file to deploy the cluster.
    * See calico installation under Deployment in [wiki](https://github.com/GlueOps/terraform-module-cloud-aws-kubernetes-cluster/wiki#deployment)

3. Access the new Kubernetes Cluster by creating a [kubeconfig](https://github.com/GlueOps/terraform-module-cloud-aws-kubernetes-cluster/wiki#create-a-kubeconfig)

4. Now that Kubernetes is deployed and can be accessed, begin [deploying the GlueOps Platform](#Deploying-GlueOps-the-Platform)

<br /><br />

## Deploying GlueOps the Platform

1. Deploy ArgoCD
    * The below command installs ArgoCD CRDs, ArgoCD Helm Chart, and watches services until they are available
    
    ```sh
    source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/placeholder_tools_version/tools/glueops-platform/deploy-argocd) && \
        deploy-argocd -c placeholder_argocd_crd_version -h placeholder_argocd_helm_chart_version
    ```

    * Ensure all services are available and running before proceeding to the next step

2. Deploy the GlueOps Platform
    * Install the GlueOps platform using

    ```sh
    source <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/placeholder_tools_version/tools/glueops-platform/deploy-glueops-platform) && \
        deploy-glueops-platform -v placeholder_glueops_platform_version
    ```

    * [Configure Vault](https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration)
3. Access Cluster services
    * [ArgoCD](https://argocd.placeholder_repo_name): https://argocd.placeholder_repo_name
    * [Valult](https://vault.placeholder_repo_name): https://vault.placeholder_repo_name
    * [Grafana](https://grafana.placeholder_repo_name): https://grafana.placeholder_repo_name

<br /><br />

## Using the GlueOps Platform with an Example Tenant

This cluster has been deployed for the environment: `placeholder_cluster_environment` belonging to the tenant: `placeholder_tenant_key`.<br />To deploy tenant applications, ArgoCD will look for a `deployment-configurations` repository at `git@github.com:placeholder_tenant_github_org_name/deployment-configurations.git`, a repository which contains configurations for tenant applications to deploy.
<br /><br />As of this version, the `deployment-configurations` repository is not created automatically and must be deployed manually to test tenant functionality.<br /><br />An [example deployment-configurations repository](https://github.com/GlueOps/deployment-configurations) can be found in the GlueOps organization and [documentation covering its usage](https://glueops.dev/docs/glueops-platform-administrator/configuration/glueops-deployment-configuration) is available on the GlueOps website.<br />
In addition to creating the `deployment-configurations` repository, you must install the applicable github application that was used for this cluster deployment.

<br /><br />

## Delete Tenant Data From S3

Use the following command to destroy any backups/ephemeral data when you created your cluster.
* [Launch a CloudShell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-west-2) within the Primary/Root AWS Account.
    * Execute the following command in the cloudshell.  When prompted, enter the name of your captain domain (e.g. test-001-np.earth.onglueops.rocks ).

```sh
bash <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/placeholder_tools_version/tools/aws/tenant-s3-nuke.sh)
```

## Teardown Kubernetes

- [AWS](#AWS-Teardown)
- [GCP](#GCP-Teardown)
- [k3d](#k3d-teardown)

### AWS Teardown

Use the following command to destroy the cluster when it is no longer needed.
* [Launch a CloudShell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-west-2) within the Primary/Root AWS Account.
    * Execute the following command in the cloudshell.  When prompted, enter the name of your captain account (e.g. glueops-captain-laciudaddelgato).

```sh
bash <(curl -s https://raw.githubusercontent.com/GlueOps/development-only-utilities/placeholder_tools_version/tools/aws/account-nuke.sh)
```

### GCP Teardown

Use the following command to destroy the cluster when it is no longer needed.
* [Launch a CloudShell](https://console.cloud.google.com/home/dashboard?cloudshell=true) within your developer GCP account.
    * Execute the following command in the cloudshell.  Click 'Authorize' if prompted and confirm the deletion of the project

```sh
    gcloud alpha billing projects unlink PROJECT_ID -q && gcloud projects delete PROJECT_ID -q
```

**NOTE: PROJECT_ID needs to be replaced with your actual Project ID.**

### k3d Teardown

Login to the AWS Lightsail account and delete the nodes with your captain domain. You can tear down your cluster locally with:

```bash
k3d cluster delete captain
```

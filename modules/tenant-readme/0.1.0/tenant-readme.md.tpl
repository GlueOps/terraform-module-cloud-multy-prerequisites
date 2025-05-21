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
2. Create a new Cloud Development Environment in `#developer-workspaces` slack channel.
3. This repository, `placeholder_repo_name`, cloned into the codespace required above. Once the Codespace is created, the repo can be cloned using 

```sh
gh repo clone placeholder_github_owner/placeholder_repo_name
```

<br /><br />

## Select Cloud
- [Deploy kubernetes (e.g. AWS/GCP/K3ds/Kubeadm/etc.)](https://glueops.getoutline.com/doc/k8s-cluster-setup-ZSRoUPqfM2)

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


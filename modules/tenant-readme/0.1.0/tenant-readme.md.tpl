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
2. Create a new Cloud Development Environment (CDE) using `@GlueOps` in slack
3. This repository, `placeholder_repo_name`, cloned into the CDE. Once the CDE is created, the repo can be cloned using 

```sh
gh repo clone placeholder_github_owner/placeholder_repo_name
```

<br /><br />

## Select a Cloud and Deploy K8s
- [Deploy kubernetes (e.g. AWS/GCP/K3ds/Kubeadm/etc.)](https://glueops.getoutline.com/doc/k8s-cluster-setup-ZSRoUPqfM2)

<br /><br />

## Deploying GlueOps the Platform

1. Deploy ArgoCD
    * From the root of this repository run:

    ```sh
    captain_utils
    ```

    * Then step through the menus:
        1. Select `production`
        2. Select `argocd`
        3. Select the ArgoCD helm chart version (pinned by `VERSIONS/glueops.yaml`)
        4. Select the ArgoCD App Version (pinned by `VERSIONS/glueops.yaml`)
        5. Review the diff shown in the pager, then press `q` to exit it
        6. Confirm `Apply upgrade`. This installs the ArgoCD CRDs, the kube-prometheus-stack CRDs, and the ArgoCD Helm Chart.
    * Ensure all services are available and running before proceeding to the next step (`captain_utils` -> `production` -> `inspect_pods`, or `watch kubectl get pods -n glueops-core`)

2. Deploy the GlueOps Platform
    * Run `captain_utils` again:

    ```sh
    captain_utils
    ```

    * Then step through the menus:
        1. Select `production`
        2. Select `glueops-platform`
        3. Select the GlueOps Platform version (pinned by `VERSIONS/glueops.yaml`)
        4. Review the diff shown in the pager, then press `q` to exit it
        5. Confirm `Apply upgrade` to install the GlueOps Platform helm chart
    * Monitor with `watch kubectl get applications -n glueops-core` until all applications are synced and healthy, except `vault`
    * [Configure Vault](https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration)
3. Access Cluster services
    * [Cluster Info](https://cluster-info.placeholder_repo_name): https://cluster-info.placeholder_repo_name
    * [ArgoCD](https://argocd.placeholder_repo_name): https://argocd.placeholder_repo_name
    * [Valult](https://vault.placeholder_repo_name): https://vault.placeholder_repo_name
    * [Grafana](https://grafana.placeholder_repo_name): https://grafana.placeholder_repo_name

<br /><br />

## Using the GlueOps Platform with an Example Tenant

This cluster has been deployed for the environment: `placeholder_cluster_environment` belonging to the tenant: `placeholder_tenant_key`.<br />To deploy tenant applications, ArgoCD will look for a `deployment-configurations` repository at `git@github.com:placeholder_tenant_github_org_name/deployment-configurations.git`, a repository which contains configurations for tenant applications to deploy.
<br /><br />As of this version, the `deployment-configurations` repository is not created automatically and must be deployed manually to test tenant functionality.<br /><br />An [example deployment-configurations repository](https://github.com/GlueOps/deployment-configurations) can be found in the GlueOps organization and [documentation covering its usage](https://glueops.dev/docs/glueops-platform-administrator/configuration/glueops-deployment-configuration) is available on the GlueOps website.<br />
In addition to creating the `deployment-configurations` repository, you must install the applicable github application that was used for this cluster deployment.

<br /><br />


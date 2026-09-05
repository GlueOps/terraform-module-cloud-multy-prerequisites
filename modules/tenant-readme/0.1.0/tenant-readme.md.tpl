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

All platform components are installed from this repository with `captain_utils`, the menu-driven tool
shipped in the CDE. It reads every version it installs from `VERSIONS/glueops.yaml` in this repository,
so the steps below never take a version argument.

* Your CDE must run codespace version `placeholder_codespace_version` (the `codespace_version` pinned in
  `VERSIONS/glueops.yaml`); `captain_utils` checks the image version on start and asks you to confirm before continuing on a mismatch.
* Run `captain_utils` from the root of your clone of this repository, choose `production`, then pick the
  menu items below in this exact order. Each item shows what it is about to change and asks for confirmation when
  there are changes (the `crds` step applies without a prompt when nothing changed, to record ownership of the CRDs).

1. Apply the platform CRDs: `captain_utils` -> `production` -> `crds`
    * Applies the GlueOps/platform-crds bundle at the `platform_crds_version` pinned in `VERSIONS/glueops.yaml`
      (every CRD the platform needs, including ArgoCD's own) with `kubectl apply --server-side`.
    * Review the diff (on a fresh cluster every CRD is new), then confirm.

2. Deploy ArgoCD: `captain_utils` -> `production` -> `argocd`
    * Runs `helm diff` and, after confirmation, `helm upgrade --install` of the ArgoCD chart at the
      `argocd_helm_chart_version` pinned in `VERSIONS/glueops.yaml`, using `argocd.yaml` (which carries the
      `argocd_app_version` image tag).
    * Ensure all ArgoCD services are available and running before proceeding to the next step.
    * **Upgrading an existing cluster? Run step 4 first.** `argocd.yaml` routes through Traefik
      middlewares that the platform chart creates, so on an upgrade this step can land before they
      exist. Traefik drops a router whose middleware is missing, which makes
      `argocd.placeholder_repo_name` answer 404 -- the browser UI as well as the CLI -- until ArgoCD
      has synced the platform chart's `glueops-core-traefik-crds-and-middleware` Application. Step 4
      only creates that Application; the middlewares arrive with its sync-waves, so the outage
      outlasts the `helm upgrade` itself. Nothing is exposed by this (the route is removed, so no
      unauthenticated request reaches ArgoCD) and it clears once that Application syncs, but the
      outage is avoidable.
      On a **fresh** cluster keep the order below: nothing is serving yet, and ArgoCD has to exist
      before the platform chart's Applications can sync.

3. Re-apply the platform CRDs: `captain_utils` -> `production` -> `crds`
    * Recreates anything the ArgoCD Helm release removed. This normally reports "No CRD content changes …
      applying to record ownership" and finishes without a prompt.

4. Deploy the GlueOps Platform: `captain_utils` -> `production` -> `glueops-platform`
    * Runs `helm diff` and, after confirmation, `helm upgrade --install` of the GlueOps platform chart
      `placeholder_glueops_platform_version` (the `glueops_platform_helm_chart_version` pinned in
      `VERSIONS/glueops.yaml`) using `platform.yaml`.
    * [Configure Vault](https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration)

5. Access Cluster services
    * [Cluster Info](https://cluster-info.placeholder_repo_name): https://cluster-info.placeholder_repo_name
    * [ArgoCD](https://argocd.placeholder_repo_name): https://argocd.placeholder_repo_name
    * [Valult](https://vault.placeholder_repo_name): https://vault.placeholder_repo_name
    * [Grafana](https://grafana.placeholder_repo_name): https://grafana.placeholder_repo_name
    * Command line (`argocd`, `bao`): [GlueOps/toolbox](https://github.com/GlueOps/toolbox) --
      `./toolbox up placeholder_repo_name`, then `./toolbox argocd app list` or
      `./toolbox bao kv get secret/my-app`. Everything above sits behind oauth2-proxy, which expects
      a browser session cookie; toolbox handles the token and the headers so the CLIs behave
      normally. You do not need `kubectl` or cluster access to use it.

<br /><br />

## Using the GlueOps Platform with an Example Tenant

This cluster has been deployed for the environment: `placeholder_cluster_environment` belonging to the tenant: `placeholder_tenant_key`.<br />To deploy tenant applications, ArgoCD will look for a `deployment-configurations` repository at `git@github.com:placeholder_tenant_github_org_name/deployment-configurations.git`, a repository which contains configurations for tenant applications to deploy.
<br /><br />As of this version, the `deployment-configurations` repository is not created automatically and must be deployed manually to test tenant functionality.<br /><br />An [example deployment-configurations repository](https://github.com/GlueOps/deployment-configurations) can be found in the GlueOps organization and [documentation covering its usage](https://glueops.dev/docs/glueops-platform-administrator/configuration/glueops-deployment-configuration) is available on the GlueOps website.<br />
In addition to creating the `deployment-configurations` repository, you must install the applicable github application that was used for this cluster deployment.

<br /><br />


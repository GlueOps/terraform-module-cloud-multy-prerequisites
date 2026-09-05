# Changelog

## [0.92.1](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.92.0...v0.92.1) (2026-09-05)


### Bug Fixes

* generate the vault configuration against v0.15.1 ([#730](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/730)) ([68ae97a](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/68ae97a7531fd83d8eaa611b6c2e1d9a4bce48b3))

## [0.92.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.91.0...v0.92.0) (2026-09-05)


### Features

* generate the vault configuration against v0.15.0 ([#728](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/728)) ([154aaaf](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/154aaaf7368c6dca85ba48d810ac2d728330b5b7))

## [0.91.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.90.0...v0.91.0) (2026-09-05)


### Features

* update github.com/glueops/docs-argocd to v0.21.0 #minor ([#722](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/722)) ([cfaf36a](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/cfaf36a014624041acf06f91066700512115c534))
* update glueops/codespaces to v0.161.1 #minor ([#718](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/718)) ([53f59a4](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/53f59a4ad298a02342d19221eb521d0e807dc135))
* update glueops/docs-argocd to v0.21.0 #minor ([#724](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/724)) ([af137c8](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/af137c8f7238e6b2716b460a2085dfd64b279b5b))
* update glueops/platform-helm-chart-platform to v0.79.0 #minor ([#725](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/725)) ([8b59cba](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/8b59cbaedab21b67a135704c44a9f9de17214fd8))


### Documentation

* warn about the argocd/platform upgrade order and point at toolbox ([#720](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/720)) ([e6e8067](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/e6e8067d321a71fd5bd5094c234b633b4ea66d17))

## [0.90.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.89.0...v0.90.0) (2026-08-28)


### Features

* update glueops/codespaces to v0.160.0 #minor ([#716](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/716)) ([5ff0a44](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/5ff0a4489ee63e35fd095a01def40ddaa9638e2f))

## [0.89.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.88.0...v0.89.0) (2026-08-28)


### ⚠ BREAKING CHANGES

* pin the platform-crds bundle version and route the tenant README through captain_utils ([#708](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/708))

### Features

* pin the platform-crds bundle version and route the tenant README through captain_utils ([#708](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/708)) ([0906b95](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/0906b95673d8d4f33a2ec052939cd661da5af75d))

## [0.88.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.87.0...v0.88.0) (2026-08-17)


### ⚠ BREAKING CHANGES

* tenants still on the wrapper that pass opsgenie_emails must delete that one argument (it has had no effect for a long time); the per-cluster modules never accepted it.

### Features

* split root module into tenant-base and captain-cluster modules ([#662](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/662)) ([a08bda1](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/a08bda1099eaeee8714ee016e9ea6a9665cb854e))

## [0.87.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.86.0...v0.87.0) (2026-08-07)


### Features

* update aws eks module ([#690](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/690)) ([315da52](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/315da52900f89bcbe3a1f7ba5c94edfb0e8c8150))
* update aws versions ([#689](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/689)) ([dcfd429](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/dcfd429c0be0b5bfd59e8aeee2dc3b888eb5e800))
* update glueops/codespaces to v0.155.1 #minor ([#685](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/685)) ([9253416](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/92534166fb22cec81b2ec1b057cd03dac25d7e19))

## [0.86.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.85.0...v0.86.0) (2026-08-03)


### Features

* update glueops/platform-helm-chart-platform to v0.77.0 #minor ([#687](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/687)) ([aa35cf7](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/aa35cf77070ca8a3e58563a902ccb0a9003a1f8b))


### Miscellaneous Chores

* add Apache-2.0 LICENSE ([#683](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/683)) ([1951b86](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/1951b86e30f513dab84d6f71e88583a68ac658de))

## [0.85.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.84.5...v0.85.0) (2026-07-25)


### Features

* update github.com/glueops/platform-helm-chart-platform to v0.76.0 #minor ([#672](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/672)) ([8d409c5](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/8d409c5d72fbae628ee45dbccd65b350eef9fc9a))
* update glueops/platform-helm-chart-platform to v0.76.0 #minor ([#673](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/673)) ([66e6e5e](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/66e6e5e11f64c94981fe9c8b4e63779926fd55e2))

## [0.84.5](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.84.4...v0.84.5) (2026-07-23)


### Miscellaneous Chores

* **patch:** update glueops/platform-helm-chart-platform to v0.75.4 #patch ([#670](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/670)) ([692edb3](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/692edb3277ac2f22e14f7e496ac29600109d8be5))

## [0.84.4](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.84.3...v0.84.4) (2026-07-23)


### Miscellaneous Chores

* **patch:** update glueops/platform-helm-chart-platform to v0.75.3 #patch ([#668](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/668)) ([9eb1683](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/9eb16831fcbe8a3a80cd729a4b8188a810ba6bee))

## [0.84.3](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.84.2...v0.84.3) (2026-07-10)


### Miscellaneous Chores

* **patch:** update glueops/platform-helm-chart-platform to v0.75.2 #patch ([#657](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/657)) ([60e55fb](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/60e55fbbd45b0410848ed31a5436dad93aeec729))

## [0.84.2](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.84.1...v0.84.2) (2026-07-10)


### Miscellaneous Chores

* **patch:** update github.com/glueops/platform-helm-chart-platform to v0.75.2 #patch ([#652](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/652)) ([96b09da](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/96b09da9bdd85ff731102be819b502060acd8a74))

## [0.84.1](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.84.0...v0.84.1) (2026-07-10)


### Miscellaneous Chores

* **patch:** update glueops/platform-helm-chart-platform to v0.75.1 #patch ([#655](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/655)) ([544203c](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/544203c9642520c2116c269ab831773839ddb7f0))

## [0.84.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.83.2...v0.84.0) (2026-07-10)


### Features

* adding vault updater policy/role #minor ([#644](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/644)) ([c00c346](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/c00c3462a99f4383ffeb951589fd5e305511437b))
* update github.com/glueops/platform-helm-chart-platform to v0.74.0 #minor ([#649](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/649)) ([25862bd](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/25862bd049479382c704c48eaedffe6e55444727))
* update glueops/codespaces to v0.146.1 #minor ([#654](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/654)) ([76187b0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/76187b051efecec2aa502b20c5492cfd676582c2))
* update glueops/platform-helm-chart-platform to v0.74.0 #minor ([#650](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/650)) ([5bb2bcd](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/5bb2bcddfc781b2140d8ebef52efdf3a26487ff9))
* update glueops/platform-helm-chart-platform to v0.75.0 #minor ([#653](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/653)) ([b414649](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/b414649e0bbf55f65d420216847a24a8ad61d736))
* update glueops/terraform-module-kubernetes-hashicorp-vault-configuration to v0.13.0 #minor ([#651](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/651)) ([f0bb53d](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/f0bb53d3e19fed540d2af5ff0b68ff5025e22a35))


### Bug Fixes

* variables.tf ([#646](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/646)) ([79b7e20](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/79b7e20a122dda122cb1a0ad7adc0e5462f0b935))


### Miscellaneous Chores

* **patch:** update glueops/terraform-module-kubernetes-hashicorp-vault-configuration to v0.12.1 #patch ([#647](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/647)) ([e158d9d](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/e158d9d08253eafb09f1f89ef43c6b07d0af67fb))

## [0.83.2](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.83.1...v0.83.2) (2026-07-03)


### Bug Fixes

* terraform provider versions (updating AWS to latest version) ([#640](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/640)) ([6c48a66](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/6c48a666b4bfeb25033d77a4f952b55e76c0e81d))

## [0.83.1](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.83.0...v0.83.1) (2026-07-03)


### Bug Fixes

* aws terraform module version ([#638](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/638)) ([2d0ab02](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/2d0ab021d6957ed67828155b6a14b8ec7a7b0cdf))

## [0.83.0](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/compare/v0.82.0...v0.83.0) (2026-07-03)


### Features

* adding gatekeeper ([#636](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/636)) ([48e543a](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/48e543a2af7a2d5f713099f8ef1e4d1b0da9e70f))
* update glueops/platform-helm-chart-platform to v0.73.1 #minor ([2b261b6](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/2b261b6a68d4b43224fd37f004e123d4e5eb896e))


### Documentation

* automated update of terraform docs ([8880967](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/888096760d9ac475ae882615adb4acd9a33dd24a))


### Continuous Integration

* add release-please ([#632](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/issues/632)) ([d280542](https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites/commit/d28054273ef7f3b1f5245e70fd804219c431bcc3))

## [2.2.2-next.2](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.2.2-next.1...2.2.2-next.2) (2025-12-26)


### Bug Fixes

* corrected config error and missing xaudio2 dll ([#39](https://github.com/Johnny-Knighten/ark-sa-server/issues/39)) ([1db674c](https://github.com/Johnny-Knighten/ark-sa-server/commit/1db674c79087488c8a6e252aa9aaf9d4e18ede18))

## [2.2.2-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.2.1...2.2.2-next.1) (2025-12-21)


### Bug Fixes

* moved force_install_dir before login in steamcmd args ([#38](https://github.com/Johnny-Knighten/ark-sa-server/issues/38)) ([4308238](https://github.com/Johnny-Knighten/ark-sa-server/commit/4308238c1c2eee47a4a69a0b8fe0ccac36e8d88c))

## [2.2.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.2.0...2.2.1) (2025-12-09)


### Bug Fixes

* remove leading directory components from backup archives ([#36](https://github.com/Johnny-Knighten/ark-sa-server/issues/36)) ([82acd9b](https://github.com/Johnny-Knighten/ark-sa-server/commit/82acd9b56ab1a82549aa42601f8edab49ef96f8b)), closes [#33](https://github.com/Johnny-Knighten/ark-sa-server/issues/33)

## [2.2.0](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.1.0...2.2.0) (2025-11-07)


### Features

* Enable using config variables like VariableName[index] ([#34](https://github.com/Johnny-Knighten/ark-sa-server/issues/34)) ([a3d0d3e](https://github.com/Johnny-Knighten/ark-sa-server/commit/a3d0d3e09b3d62f8993efc34a44d9bdf75e74270))

## [2.1.0](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.0.0...2.1.0) (2025-08-04)


### Bug Fixes

* added default value for CLUSTER_DIR and made it depend on CLUSTER_ID ([8582cdf](https://github.com/Johnny-Knighten/ark-sa-server/commit/8582cdf55172ccee9841e3aea7de4d8b2563f561))
* remove hardcoded ubuntu dependencies to prevent build issues due to some versions missing ([d8281c0](https://github.com/Johnny-Knighten/ark-sa-server/commit/d8281c01a4f860064a0f39adcf3f861963efd551))
* removed depend test against tzdata since a specific version is no longer installed ([867c6da](https://github.com/Johnny-Knighten/ark-sa-server/commit/867c6da468eb34bf50741b056c1c857070375619))


### Features

* added required cluster startup flags and env vars ([668e3aa](https://github.com/Johnny-Knighten/ark-sa-server/commit/668e3aaf848b4be997ce3ff73aa163cabcad91ea))
* initial server clustering setup ([2013d79](https://github.com/Johnny-Knighten/ark-sa-server/commit/2013d79e19379748e4aff16b1026e4791a4e4d5d))

## [2.1.0-next.2](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.1.0-next.1...2.1.0-next.2) (2025-08-04)


### Bug Fixes

* added default value for CLUSTER_DIR and made it depend on CLUSTER_ID ([8582cdf](https://github.com/Johnny-Knighten/ark-sa-server/commit/8582cdf55172ccee9841e3aea7de4d8b2563f561))

## [2.1.0-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.0.0...2.1.0-next.1) (2025-07-30)


### Bug Fixes

* remove hardcoded ubuntu dependencies to prevent build issues due to some versions missing ([d8281c0](https://github.com/Johnny-Knighten/ark-sa-server/commit/d8281c01a4f860064a0f39adcf3f861963efd551))
* removed depend test against tzdata since a specific version is no longer installed ([867c6da](https://github.com/Johnny-Knighten/ark-sa-server/commit/867c6da468eb34bf50741b056c1c857070375619))


### Features

* added required cluster startup flags and env vars ([668e3aa](https://github.com/Johnny-Knighten/ark-sa-server/commit/668e3aaf848b4be997ce3ff73aa163cabcad91ea))
* initial server clustering setup ([2013d79](https://github.com/Johnny-Knighten/ark-sa-server/commit/2013d79e19379748e4aff16b1026e4791a4e4d5d))

## [2.0.0](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.0.2...2.0.0) (2023-11-30)


### ⚠ BREAKING CHANGES

* every existing container deployment will need their env var names updated
* breaking out into multiple volumes will require data transfer

### Bug Fixes

* added -l to useradd and made PGID and PUID build args ([e121ad1](https://github.com/Johnny-Knighten/ark-sa-server/commit/e121ad1cc76a9357a154a5c8a78d5fa1aef49392))
* added dummy user/password to prevent warning msg at boot ([86a555e](https://github.com/Johnny-Knighten/ark-sa-server/commit/86a555eded96fbd0d81e3fe4ea760c7e545a3edf))
* added info log to list configs updated ([31f1ca5](https://github.com/Johnny-Knighten/ark-sa-server/commit/31f1ca5f70bbfb1a633b70ca3f13aaa6d10e8d10))
* added python3 to dockerfile install and updated dependency tests ([b6db7e2](https://github.com/Johnny-Knighten/ark-sa-server/commit/b6db7e2e39f9bfa355eb36fab41f006880de2fdc))
* added unzip to container and related test ([470e128](https://github.com/Johnny-Knighten/ark-sa-server/commit/470e128cbccde16c5dfde081ee4c7396010616cb))
* caught edge case of no backups existing if it is first time creating config ([6e92fdf](https://github.com/Johnny-Knighten/ark-sa-server/commit/6e92fdf9bc6f94dbe3c0149ed64a6e62b1db6a15))
* converted proton env vars to build args ([84f3eaf](https://github.com/Johnny-Knighten/ark-sa-server/commit/84f3eaf6049d385d0621a7b8b27cc426e8281ca4))
* corrected syntax issue in ark-sa-bootstrap ([b85efc0](https://github.com/Johnny-Knighten/ark-sa-server/commit/b85efc0a5119cc5de30f04a1105891ad7850668f))
* fixed bug that stopped new configs being updated when CONFIG_ values changed ([be8e4e3](https://github.com/Johnny-Knighten/ark-sa-server/commit/be8e4e3614b7dfdaf518de16efd4c67c9dd2b6f6))
* integrated new python config generation into ark-sa-bootstrap ([8060e1a](https://github.com/Johnny-Knighten/ark-sa-server/commit/8060e1ae3f79017ced1c98f338bfb8193fb41c9a))
* made ark-sa-server responsible for starting ark-sa-updater ([a27c950](https://github.com/Johnny-Knighten/ark-sa-server/commit/a27c95090df20ebd23a768ea505550c1a22f79fc))
* prevent early shootergame log tail by deleteing old logs first ([0524b82](https://github.com/Johnny-Knighten/ark-sa-server/commit/0524b8279f7434b9d7924c10337395321837c343))
* removes user/pw from supervisord conf due to launch issues ([91cf811](https://github.com/Johnny-Knighten/ark-sa-server/commit/91cf81191882de245ecaf4bd2f6f3535c38ce2fe))
* updated config_from_env_vars to main capitalization and remove spaces around = ([ae9e790](https://github.com/Johnny-Knighten/ark-sa-server/commit/ae9e7901437d4738caddeea2513079a394e5b5fd))


### Code Refactoring

* renamed all env vars to drop ARK prefix ([d77c80c](https://github.com/Johnny-Knighten/ark-sa-server/commit/d77c80ce2620ec2dbdb0224e97ab46ebf0e4be8b))


### Features

* added backup on container stop ([e4c704c](https://github.com/Johnny-Knighten/ark-sa-server/commit/e4c704c72f447678ef6891b8512d1c04d72f7abd))
* added option to limit # of backups stored ([dbe7dfd](https://github.com/Johnny-Knighten/ark-sa-server/commit/dbe7dfd1bbd80d7fa234b6f4feca446f141ed72a))
* added scheduled restarts ([16ca5f1](https://github.com/Johnny-Knighten/ark-sa-server/commit/16ca5f114fd238599cf0f1d47e78df3b236dfca2))
* added scheduled update cron ([51bf6a5](https://github.com/Johnny-Knighten/ark-sa-server/commit/51bf6a527f37d563ef15278e1b8ba70972be7135))
* added scheduled updates ([765af0c](https://github.com/Johnny-Knighten/ark-sa-server/commit/765af0c1c4adebce3cda5214a7e50fb1df258a32))
* added timezone config to container ([90c053e](https://github.com/Johnny-Knighten/ark-sa-server/commit/90c053e19325f510ef8c47fc8c99a9f29ecda85a))
* configs are now backedup instead of overwritten, and removing CONFIG_ vars now also remove it from config ([d204ee6](https://github.com/Johnny-Knighten/ark-sa-server/commit/d204ee633d9c7cdbcbbf3cd5a12ec4c839de992d))
* created python script to extract env vars and convert to ini files ([26745c4](https://github.com/Johnny-Knighten/ark-sa-server/commit/26745c4e4a61d5fb75c729673f47c8fe0eef888e))
* created supervisord controlled process to install/update server ([b07adef](https://github.com/Johnny-Knighten/ark-sa-server/commit/b07adef7898cc5097174d9142f589ac01038056a))
* created supervisord controlled process to start ark sa server ([acbe0e8](https://github.com/Johnny-Knighten/ark-sa-server/commit/acbe0e8825ad0472773ac787835915535455aa69))
* installed cron inside container ([28d6d6e](https://github.com/Johnny-Knighten/ark-sa-server/commit/28d6d6e37a5c3d2bd3ce1cb4b49197f2278ac5e7))
* introduce the option to store backups as zip instead of tar.gz ([1a26e08](https://github.com/Johnny-Knighten/ark-sa-server/commit/1a26e08f24e1c39987f780a40f4feaad76b3987b))
* introduced backups on restarts and before updates ([183629f](https://github.com/Johnny-Knighten/ark-sa-server/commit/183629f19a8ac466c3536b6050eae2bf0cc97bfe))
* introduced MANUAL_CONFIG to control if config file generation should be used ([3b72b1f](https://github.com/Johnny-Knighten/ark-sa-server/commit/3b72b1f0bd935a370ab8d466f5705311c94d907f))
* now using supervisor as our process manager ([02dbc14](https://github.com/Johnny-Knighten/ark-sa-server/commit/02dbc1484bc76cbbfb9a222abf265b54b7443f61))

## [2.0.0-next.4](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.0.0-next.3...2.0.0-next.4) (2023-11-30)


### Bug Fixes

* added info log to list configs updated ([31f1ca5](https://github.com/Johnny-Knighten/ark-sa-server/commit/31f1ca5f70bbfb1a633b70ca3f13aaa6d10e8d10))
* added python3 to dockerfile install and updated dependency tests ([b6db7e2](https://github.com/Johnny-Knighten/ark-sa-server/commit/b6db7e2e39f9bfa355eb36fab41f006880de2fdc))
* caught edge case of no backups existing if it is first time creating config ([6e92fdf](https://github.com/Johnny-Knighten/ark-sa-server/commit/6e92fdf9bc6f94dbe3c0149ed64a6e62b1db6a15))
* corrected syntax issue in ark-sa-bootstrap ([b85efc0](https://github.com/Johnny-Knighten/ark-sa-server/commit/b85efc0a5119cc5de30f04a1105891ad7850668f))
* fixed bug that stopped new configs being updated when CONFIG_ values changed ([be8e4e3](https://github.com/Johnny-Knighten/ark-sa-server/commit/be8e4e3614b7dfdaf518de16efd4c67c9dd2b6f6))
* integrated new python config generation into ark-sa-bootstrap ([8060e1a](https://github.com/Johnny-Knighten/ark-sa-server/commit/8060e1ae3f79017ced1c98f338bfb8193fb41c9a))
* updated config_from_env_vars to main capitalization and remove spaces around = ([ae9e790](https://github.com/Johnny-Knighten/ark-sa-server/commit/ae9e7901437d4738caddeea2513079a394e5b5fd))


### Features

* configs are now backedup instead of overwritten, and removing CONFIG_ vars now also remove it from config ([d204ee6](https://github.com/Johnny-Knighten/ark-sa-server/commit/d204ee633d9c7cdbcbbf3cd5a12ec4c839de992d))
* created python script to extract env vars and convert to ini files ([26745c4](https://github.com/Johnny-Knighten/ark-sa-server/commit/26745c4e4a61d5fb75c729673f47c8fe0eef888e))
* introduced MANUAL_CONFIG to control if config file generation should be used ([3b72b1f](https://github.com/Johnny-Knighten/ark-sa-server/commit/3b72b1f0bd935a370ab8d466f5705311c94d907f))

## [2.0.0-next.3](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.0.0-next.2...2.0.0-next.3) (2023-11-27)


### ⚠ BREAKING CHANGES

* every existing container deployment will need their env var names updated

### Code Refactoring

* renamed all env vars to drop ARK prefix ([d77c80c](https://github.com/Johnny-Knighten/ark-sa-server/commit/d77c80ce2620ec2dbdb0224e97ab46ebf0e4be8b))

## [2.0.0-next.2](https://github.com/Johnny-Knighten/ark-sa-server/compare/2.0.0-next.1...2.0.0-next.2) (2023-11-27)


### Bug Fixes

* added unzip to container and related test ([470e128](https://github.com/Johnny-Knighten/ark-sa-server/commit/470e128cbccde16c5dfde081ee4c7396010616cb))

## [2.0.0-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.1.0-next.2...2.0.0-next.1) (2023-11-27)


### ⚠ BREAKING CHANGES

* breaking out into multiple volumes will require data transfer

### Features

* added backup on container stop ([e4c704c](https://github.com/Johnny-Knighten/ark-sa-server/commit/e4c704c72f447678ef6891b8512d1c04d72f7abd))
* added option to limit # of backups stored ([dbe7dfd](https://github.com/Johnny-Knighten/ark-sa-server/commit/dbe7dfd1bbd80d7fa234b6f4feca446f141ed72a))
* added scheduled update cron ([51bf6a5](https://github.com/Johnny-Knighten/ark-sa-server/commit/51bf6a527f37d563ef15278e1b8ba70972be7135))
* introduce the option to store backups as zip instead of tar.gz ([1a26e08](https://github.com/Johnny-Knighten/ark-sa-server/commit/1a26e08f24e1c39987f780a40f4feaad76b3987b))
* introduced backups on restarts and before updates ([183629f](https://github.com/Johnny-Knighten/ark-sa-server/commit/183629f19a8ac466c3536b6050eae2bf0cc97bfe))

## [1.1.0-next.2](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.1.0-next.1...1.1.0-next.2) (2023-11-24)


### Bug Fixes

* prevent early shootergame log tail by deleteing old logs first ([0524b82](https://github.com/Johnny-Knighten/ark-sa-server/commit/0524b8279f7434b9d7924c10337395321837c343))
* removes user/pw from supervisord conf due to launch issues ([91cf811](https://github.com/Johnny-Knighten/ark-sa-server/commit/91cf81191882de245ecaf4bd2f6f3535c38ce2fe))

## [1.1.0-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.0.2...1.1.0-next.1) (2023-11-24)


### Bug Fixes

* added -l to useradd and made PGID and PUID build args ([e121ad1](https://github.com/Johnny-Knighten/ark-sa-server/commit/e121ad1cc76a9357a154a5c8a78d5fa1aef49392))
* added dummy user/password to prevent warning msg at boot ([86a555e](https://github.com/Johnny-Knighten/ark-sa-server/commit/86a555eded96fbd0d81e3fe4ea760c7e545a3edf))
* converted proton env vars to build args ([84f3eaf](https://github.com/Johnny-Knighten/ark-sa-server/commit/84f3eaf6049d385d0621a7b8b27cc426e8281ca4))
* made ark-sa-server responsible for starting ark-sa-updater ([a27c950](https://github.com/Johnny-Knighten/ark-sa-server/commit/a27c95090df20ebd23a768ea505550c1a22f79fc))


### Features

* added scheduled restarts ([16ca5f1](https://github.com/Johnny-Knighten/ark-sa-server/commit/16ca5f114fd238599cf0f1d47e78df3b236dfca2))
* added scheduled updates ([765af0c](https://github.com/Johnny-Knighten/ark-sa-server/commit/765af0c1c4adebce3cda5214a7e50fb1df258a32))
* added timezone config to container ([90c053e](https://github.com/Johnny-Knighten/ark-sa-server/commit/90c053e19325f510ef8c47fc8c99a9f29ecda85a))
* created supervisord controlled process to install/update server ([b07adef](https://github.com/Johnny-Knighten/ark-sa-server/commit/b07adef7898cc5097174d9142f589ac01038056a))
* created supervisord controlled process to start ark sa server ([acbe0e8](https://github.com/Johnny-Knighten/ark-sa-server/commit/acbe0e8825ad0472773ac787835915535455aa69))
* installed cron inside container ([28d6d6e](https://github.com/Johnny-Knighten/ark-sa-server/commit/28d6d6e37a5c3d2bd3ce1cb4b49197f2278ac5e7))
* now using supervisor as our process manager ([02dbc14](https://github.com/Johnny-Knighten/ark-sa-server/commit/02dbc1484bc76cbbfb9a222abf265b54b7443f61))

## [1.0.2](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.0.1...1.0.2) (2023-11-20)


### Bug Fixes

* introduced GameUserSettings templating system ([4912e9c](https://github.com/Johnny-Knighten/ark-sa-server/commit/4912e9c0022d63ca8bd23592f3c598b4be1a08db))
* **config:** introduced GameUserSettings.ini template ([40e9f3b](https://github.com/Johnny-Knighten/ark-sa-server/commit/40e9f3bde4e758d5fd177a7426780930a66d985d))

## [1.0.2-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.0.1...1.0.2-next.1) (2023-11-20)


### Bug Fixes

* introduced GameUserSettings templating system ([4912e9c](https://github.com/Johnny-Knighten/ark-sa-server/commit/4912e9c0022d63ca8bd23592f3c598b4be1a08db))
* **config:** introduced GameUserSettings.ini template ([40e9f3b](https://github.com/Johnny-Knighten/ark-sa-server/commit/40e9f3bde4e758d5fd177a7426780930a66d985d))

## [1.0.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.0.0...1.0.1) (2023-11-18)


### Bug Fixes

* updated main README to reflect windows container dev ([a6f6d5a](https://github.com/Johnny-Knighten/ark-sa-server/commit/a6f6d5a03ceaf7cc8079d58d0f8644d8515de62f))

## [1.0.1-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/1.0.0...1.0.1-next.1) (2023-11-18)


### Bug Fixes

* updated main README to reflect windows container dev ([a6f6d5a](https://github.com/Johnny-Knighten/ark-sa-server/commit/a6f6d5a03ceaf7cc8079d58d0f8644d8515de62f))

## [1.0.0](https://github.com/Johnny-Knighten/ark-sa-server/compare/...1.0.0) (2023-11-14)


### Bug Fixes

* added job step to make test scripts executable ([c57e05b](https://github.com/Johnny-Knighten/ark-sa-server/commit/c57e05b8a6dd58d57f8e5bf1bab5aff69d0827e4))
* fixed the chmod command to not use CONTAINER_BIN_DIR var ([3e73610](https://github.com/Johnny-Knighten/ark-sa-server/commit/3e73610fca53cf712a69a4aab8916f9d564c64ff))
* made all bin files executable inside dockerfile ([755febd](https://github.com/Johnny-Knighten/ark-sa-server/commit/755febd5c6db93f1979384869e0b088721831998))
* made player count env var work ([9723519](https://github.com/Johnny-Knighten/ark-sa-server/commit/9723519a3d692cad7b40f539a5ed521df7cd9538))
* **core-setup:** added ARK_ENABLE_PVE env var back ([1fc4a4a](https://github.com/Johnny-Knighten/ark-sa-server/commit/1fc4a4a3659277c9c07cf18e739e8341f9b56305))
* **core-setup:** fixed wrong variable name for RCON env var ([26e95ab](https://github.com/Johnny-Knighten/ark-sa-server/commit/26e95abc88c8aeb387b8be4ba4918f260d0af577))
* **deployment-examples:** fixed port typo in basic compose ([78ac6c0](https://github.com/Johnny-Knighten/ark-sa-server/commit/78ac6c0bb93ffbd3c9ed986be2db5bbfd3195a2d))


### Features

* **core-setup:** added entrypoint script to create required directories ([cfbad94](https://github.com/Johnny-Knighten/ark-sa-server/commit/cfbad942cbf4e4c0f5d373ae7f0b26121374c0d6))
* **core-setup:** added env var flag to skip steam cmd file validation ([8356f71](https://github.com/Johnny-Knighten/ark-sa-server/commit/8356f715d6a970813ad1243c9985bc7a262da4d8))
* **core-setup:** added env var flag to stop download of server updates ([1eeb920](https://github.com/Johnny-Knighten/ark-sa-server/commit/1eeb920c6ebee9c4939b52bc798db6b938fa906b))
* **core-setup:** added more config via env vars ([329e982](https://github.com/Johnny-Knighten/ark-sa-server/commit/329e9825c181c2b64f5fa36029695e2902a4ae47))
* **core-setup:** added script to install ark sa files via steamcmd ([4c5d66a](https://github.com/Johnny-Knighten/ark-sa-server/commit/4c5d66aa2a6710c7c51b6cb8d51cc8ed5409d803))
* **core-setup:** added the ability to add mods to container ([bfa2e7a](https://github.com/Johnny-Knighten/ark-sa-server/commit/bfa2e7ad7b9e81c29ff326b620adda334f5d2e84))
* **core-setup:** created Dockerfile for dependencies and server install ([327fded](https://github.com/Johnny-Knighten/ark-sa-server/commit/327fded783c918499e1d378f0e95070e3c17a3f5))
* **core-setup:** created launch script for the server itself ([3613c24](https://github.com/Johnny-Knighten/ark-sa-server/commit/3613c24469b2ffb5d96b4bc39a9a8dd9f7a29ecc))
* **core-setup:** introduced essential launch vars as env vars ([becf19b](https://github.com/Johnny-Knighten/ark-sa-server/commit/becf19b42cba252db59c81a8a2be521914a5d14c))
* **core-setup:** moved some flags to their own env var ([9c37243](https://github.com/Johnny-Knighten/ark-sa-server/commit/9c3724324267a141930de174b52c48d49e3ab27f))

## [1.0.0-next.1](https://github.com/Johnny-Knighten/ark-sa-server/compare/...1.0.0-next.1) (2023-11-14)


### Bug Fixes

* added job step to make test scripts executable ([c57e05b](https://github.com/Johnny-Knighten/ark-sa-server/commit/c57e05b8a6dd58d57f8e5bf1bab5aff69d0827e4))
* fixed the chmod command to not use CONTAINER_BIN_DIR var ([3e73610](https://github.com/Johnny-Knighten/ark-sa-server/commit/3e73610fca53cf712a69a4aab8916f9d564c64ff))
* made all bin files executable inside dockerfile ([755febd](https://github.com/Johnny-Knighten/ark-sa-server/commit/755febd5c6db93f1979384869e0b088721831998))
* made player count env var work ([9723519](https://github.com/Johnny-Knighten/ark-sa-server/commit/9723519a3d692cad7b40f539a5ed521df7cd9538))
* **core-setup:** added ARK_ENABLE_PVE env var back ([1fc4a4a](https://github.com/Johnny-Knighten/ark-sa-server/commit/1fc4a4a3659277c9c07cf18e739e8341f9b56305))
* **core-setup:** fixed wrong variable name for RCON env var ([26e95ab](https://github.com/Johnny-Knighten/ark-sa-server/commit/26e95abc88c8aeb387b8be4ba4918f260d0af577))
* **deployment-examples:** fixed port typo in basic compose ([78ac6c0](https://github.com/Johnny-Knighten/ark-sa-server/commit/78ac6c0bb93ffbd3c9ed986be2db5bbfd3195a2d))


### Features

* **core-setup:** added entrypoint script to create required directories ([cfbad94](https://github.com/Johnny-Knighten/ark-sa-server/commit/cfbad942cbf4e4c0f5d373ae7f0b26121374c0d6))
* **core-setup:** added env var flag to skip steam cmd file validation ([8356f71](https://github.com/Johnny-Knighten/ark-sa-server/commit/8356f715d6a970813ad1243c9985bc7a262da4d8))
* **core-setup:** added env var flag to stop download of server updates ([1eeb920](https://github.com/Johnny-Knighten/ark-sa-server/commit/1eeb920c6ebee9c4939b52bc798db6b938fa906b))
* **core-setup:** added more config via env vars ([329e982](https://github.com/Johnny-Knighten/ark-sa-server/commit/329e9825c181c2b64f5fa36029695e2902a4ae47))
* **core-setup:** added script to install ark sa files via steamcmd ([4c5d66a](https://github.com/Johnny-Knighten/ark-sa-server/commit/4c5d66aa2a6710c7c51b6cb8d51cc8ed5409d803))
* **core-setup:** added the ability to add mods to container ([bfa2e7a](https://github.com/Johnny-Knighten/ark-sa-server/commit/bfa2e7ad7b9e81c29ff326b620adda334f5d2e84))
* **core-setup:** created Dockerfile for dependencies and server install ([327fded](https://github.com/Johnny-Knighten/ark-sa-server/commit/327fded783c918499e1d378f0e95070e3c17a3f5))
* **core-setup:** created launch script for the server itself ([3613c24](https://github.com/Johnny-Knighten/ark-sa-server/commit/3613c24469b2ffb5d96b4bc39a9a8dd9f7a29ecc))
* **core-setup:** introduced essential launch vars as env vars ([becf19b](https://github.com/Johnny-Knighten/ark-sa-server/commit/becf19b42cba252db59c81a8a2be521914a5d14c))
* **core-setup:** moved some flags to their own env var ([9c37243](https://github.com/Johnny-Knighten/ark-sa-server/commit/9c3724324267a141930de174b52c48d49e3ab27f))

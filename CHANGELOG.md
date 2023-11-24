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

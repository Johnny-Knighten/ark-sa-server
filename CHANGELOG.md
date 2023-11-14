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

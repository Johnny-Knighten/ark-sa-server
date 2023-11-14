# Contributing to Johnny-Knighten/ark-sa-server

We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Project Goal

The goal of this project is to provide a simple and easy to use Docker image for running an ARK: Survival Ascended dedicated server. The image should have reasonable default settings while also allowing rich configurability for end users.

### About Execution Environments and Container Types

At the time of writing, there is no Linux version of the dedicated server which has made Docker deployment slightly more difficult. This project was made to address this issue and hopefully evolves into a more robust solution.

The current plan is to have a wine-based Linux container and a Windows container. The Linux container will be the primary focus of this project. The Windows container will be a secondary focus primarily due to the [tighter requirements](https://learn.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/system-requirements) for running Windows containers. We will strive to have feature parity between the two versions.

When/if an official Linux dedicated server is released, we will switch to using that instead of the wine based Linux container. At the time of writing, we do not see a reason to maintain the wine based and native Linux based container.

## GitHub

GitHub is used for all project activities. It is used to host code, track issues, feature requests, as well as for managing pull requests.

### [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) is Our Project's Worklow

Pull Requests are the primary way to add changes to the codebase.

General PR process:

1. Create your branch from the `next` branch
    * Keep names short and descriptive
    * Name your branch according to what your PR does:
      * feat/<feature-name>
      * fix/<issue-name>
      * refactor/<what-is-refactored>
2. Develop your feature/fix and write tests were appropriate
3. Ensure our test suite passes before making a PR
    * Run the bash scripts contained in the [tests](./tests) directory to test changes made to containers
    * If making changes to our CI/CD, run the GitHub Actions workflow locally using [nektos/act](https://github.com/nektos/act)
      * See [cicd-test/README.md](./cicd-test/README.md) for details
4. Make sure your code lints
    * See [Use a Consistent Coding Style](#use-a-consistent-coding-style) for more details
5. Update any related documentation
6. Create a PR with the merge target as `next`
7. Request a review from at least one maintainer
    * All tests must pass for a PR to be approved
8. Implement any requested changes
9. Once the PR is approved, the PR is merged into `next`

We let features collect in `next` until we feel there is a need to release a new version. We will then merge `next` into `main` and release a new version.

If urgent fixes are needed in the current `main` release, then we will PR merge directly into `main` depending on the severity of the issue. With that said, also make sure your submitted PR branch is up to date with `main` and `next` before submitting your PR.

To leverage automatic CHANGELOG generation via semantic-release we will not rebase or use squash-commits when accepting PRs. We will rely on merge commits to preserve the commit history, even though they clutter history. We have branch rules in place to prevent force pushes to `main` and `next` branches. It is recommended to do an interactive rebase before merging your PR to `next` to clean up your commit history. If you force push into your own (non-protected) branch to clean up its history while in PR review, make sure to inform all assigned reviewers.

### GitHub Actions for CI/CD

There are workflows that execute when a PR is open or its code is modified, and all pushes to `main` and `next` (when a PR is merged). See [build-and-test.yml](./.github/workflows/build-and-test.yml) and [release.yml](./.github/workflows/release.yml) for details.

All tests that are executed in the [build-and-test.yml](./.github/workflows/build-and-test.yml) workflow must pass before a PR will be accepted.

### Report Bugs Using GitHub Issues

We use GitHub issues to track all bugs. Report a bug by [opening a new bug issue](https://github.com/Johnny-Knighten/ark-sa-server/issues/new?assignees=Johnny-Knighten&labels=bug&projects=&template=bug-report.md&title=%7BBUG%7D).

## Coding Style

The number one rule is to keep our code bases consistent. These are the current guidelines we follow, but are subject to change as the project evolves:

* Use 2 spaces for indentation rather than tabs
* Delete all trailing whitespace
* Use meaningful variable names
* Comment your code where needed, strive to write self-documenting code
* Lint you code
  * [hadolint](https://github.com/hadolint/hadolint) for Dockerfiles
  * [actionlint](https://github.com/rhysd/actionlint) for GitHub Actions
  * [shellcheck](https://github.com/koalaman/shellcheck) for bash scripts

## Commit Messages

We use the [Conventional Commits](https://www.conventionalcommits.org/) specification for our commit messages. This allows semantic-release to automatically detect version changes and generate changelogs.

The commit message should be structured as follows:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```
The `<type>` and `<description>` fields are mandatory, the `scope` of the commit is optional.

Example of a commit message:
```
feat(database): add 'comments' option
```

This example indicates that a feature (feat) was added to the 'database' scope of the project.

The two main primary types used to increment the semver are `fix:` and `feat`, but some others to consider are `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, and `test:`.


## DockerHub

This project uses DockerHub as our primary container registry to distribute our Docker
image. 

See our DockerHub repo [here](https://hub.docker.com/r/johnnyknighten/ark-sa-server).

## Testing

Currently we have two test suites, one for the Docker image itself and the other for our GitHub Actions CI/CD workflows.

To run the Docker images locally, first build the image and then run the tests:
```bash
# Dependency Tests
$ ./tests/docker_dependencies.sh

# Environment Variable Tests
$ ./tests/docker_environment_variables.sh
```

To test the GitHub Actions CI/CD workflows locally see [cicd-test/README.md](./cicd-test/README.md) for details.

Please always add, remove, and update tests whenever relevant.

## Becoming a Maintainer

Maintainers play a crucial role in shaping the project's future and ensuring its stability and direction. Here’s how you can start this journey:

1. **Active Contribution:** Regularly contribute to the project through pull requests, bug fixes, and feature enhancements.
2. **Community Engagement:** Participate in discussions, help other contributors, and engage with users reporting issues.
3. **Understanding the Project:** Gain a deep understanding of the project's codebase, architecture, and roadmap.
4. **Demonstrate Leadership:** Show initiative by leading discussions, proposing new ideas, and helping to shape the project's direction.
5. **Express Interest:** Reach out to the current maintainers expressing your interest in becoming a maintainer, highlighting your contributions and engagement with the project.

Becoming a maintainer is a responsibility that comes with the commitment to be a steward of the project. It involves more than just technical expertise; it requires dedication to the project and its community. 

## Submitting PRs Without Being a Maintainer

Only project maintainers will have direct write access to the project's repo. To submit PRs without being a maintainer follow the Fork & [Pull Request Workflow](https://docs.github.com/en/get-started/quickstart/contributing-to-projects).

## License

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](LICENSE) that covers the project. Feel free to contact the maintainers if that's a concern.

## Missing Anything?

If there is anything missing from this guide open an issue and let us know!

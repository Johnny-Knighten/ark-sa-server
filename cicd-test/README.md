# Running GitHub Actions locally

I highly suggest running GitHub Actions workflows/actions/jobs/steps locally before pushing them to GitHub.  This can help you avoid having to push to GitHub multiple times to get your actions working as expected. Or from having to create a branch specifically for CI development before squashing and merging into your default/release branch.

It is also handy for just running basic tasks that are part of our CI/CD locally (building/linting/testing). Since everything is container based, you don't have to clutter your machine with tons of tech stacks and tools.

## GitHub Action Linting

We use [rhysd/actionlint](https://github.com/rhysd/actionlint) for linting our GitHub Actions. This is a great tool to use to catch syntax errors and other issues before pushing to GitHub.

## Required Dependencies

We will use [nektos/act](https://github.com/nektos/act) to run GitHub actions locally which requires Docker to be installed on your machine.

Details here:
* [Docker](https://docs.docker.com/get-docker/)
* [nektos/act](https://github.com/nektos/act)

Act will pull images that are compatible with the ones referenced in our GitHub Actions and then use  them to execute GitHub Action workflows/actions/jobs/steps locally. You can also run your own custom image if needed, see [here](https://nektosact.com/usage/runners.html).

## Modifications Made To Ensure Actions Are Testable Via `nektos/act`

We had to make some modifications to our GitHub Actions to overcome some limitations of `nektos/act`. These modifications are only required if you want to test your actions locally. They are not required for the actions to run on GitHub.

### No Support For `actions/cache`

`nektos/act` does not directly support the [actions/cache](https://github.com/actions/cache) action. To get around this issue we will need to do a couple things:
1. On every actions/cache action we will need to add `if: ${{ !env.ACT }}`
    * This will prevent the actions/cache action from running when we are testing locally
    * nektos/act injects an environment variable `ACT`, so we can use it as an easy flag to catch local testing
2. We add the `--reuse` flag to the act command
    * `--reuse` will reuse the same container for each action
    * This effectively gets us the same effect as using a cache

The major downside to this is that the `--reuse` flag will cause containers to not be automatically deleted between runs. You will need to periodically clean these up if your executing a lot of actions locally.

Note - Here is the [issue](https://github.com/nektos/act/issues/285#issuecomment-987550101) that detailed using `--reuse` as a workaround for cache.

### When Testing Locally We Do not Want Some Actions To Actually Run

We don't want some actions to actually run when we are testing locally because of the side effects they  cause. For example, we don't want to actually publish a docker image to DockerHub when we are testing locally. Another example is we do not want to perform an actual GitHub release when using semantic-release.

To workaround this we:

1. Add `if: ${{ !env.ACT }}` to any action/job/ste that only should run on GitHub   
2. Add `if: ${{ env.ACT }}` to any action/job/step should only run locally and not on GitHub 
    * What you do during these action/job/step depends on your end goal
      * For example:
        * semantic-release has a dry run flag, so we just need to pass that flag
        * docker/build-push-action@v3 does not have a dry run flag, so we just echo a message about generated tags

## Other Need To Knows About Using `nektos/act` In This Repo

### Event Files

Event files are used to simulate the payloads sent when workflows are launched. They contain key info such as the branch name, commit hash, etc. You can use event files to simulate how workflow behave when launched in a certain context. For example, you can simulate a workflow being launched on a `push` event on a `feature` branch.

In this repo, event files are located in the [cicd-test/events](./cicd-test/events) directory.

They look something like this:
```json
{
  "push": {
    "ref": "refs/heads/feature/new-feature",
  }
}
```

### Secrets

All workflows in this repo require some secrets to run. The two sets we will mainly be using is GitHub Tokens and DockerHub Credentials.

Note - When these workflows actually execute on GitHub they are injected into the workflows via GitHub Secrets, or in the case of GitHub Tokens they are automatically injected.

#### GitHub Secrets

When the Workflows is actually executed on GitHub a Token is injected automatically as the `GITHUB_TOKEN` environment variable. We have a couple of options to supply the secrets when running locally:

* Use GitHub CLI To Generate a Toke
  * `act -s GITHUB_TOKEN="$(gh auth token)"`
* Make A Personal Access Token And Inject It (Not Recommended Due To Exposing Token In Shell History)
  * `act -s GITHUB_TOKEN=[insert token or leave blank and omit equals for secure input]`
    * If you really want to go this route as a space in front of the `act` command to omit it from your shells history
* Create a secrets file and inject it

We will also need the `GH_TOKEN_SEMANTIC_RELEASE` that contains a PAT that will allows use to bypass pushing to a protected branch. See the Branch Setup section in the base README for more details.

#### DockerHub Secrets

On the DockerHub side of things we will need a username (`DOCKERHUB_USERNAME`) and a Personal Access Token (`DOCKERHUB_TOKEN`).

For these I 100% recommend creating a secrets file and injecting it. This will prevent you from having to expose your secrets in your shell history.

#### Secrets File

nektos/act uses Ruby's gem dotenv format through godotenv library. Here is a template to follow to setup all required secrets (name the file something like `my.secrets`):

```
export DOCKERHUB_USERNAME=USERNAME
DOCKERHUB_TOKEN=TOKEN
GITHUB_TOKEN=PAT-TOKEN-1
GH_TOKEN_SEMANTIC_RELEASE=PAT-TOKEN-2
```
**Remember - NEVER commit your secrets file. Although normally I would suggest adding something like `*.secrets` to your `.gitignore`; however, this seems to prevent act from reading from the file.**


## Available Local Executions and Tests

### Workflow - Build and Test Docker Image

Triggered on:
* These `pull_request` events types:
  * `opened`
  * `reopened`
  * `synchronize`

Goal:
* Build and test the docker image anytime a PR is `opened`/`reopened` or `synchronized` (new commits pushed to PR branch) to ensure the PR is clean and breaks no tests
  * We will rely on branch rules to ensure all statuses are passing before merging
  * We will rely on branch rules to ensure `main` and `next` branches are protected from pushes and require PRs to add new commits to those branches

See [.github/workflows/build-and-test.yml](./.github/workflows/build-and-test.yml) for exact details


#### Local Execution - Build and Test Docker Image Locally

```bash
act pull_request --secret-file ./cicd-test/my.secrets --reuse
```

#### Test - Open PR 

```bash
act pull_request --secret-file ./cicd-test/my.secrets -e ./cicd-test/events/pr-open.json --reuse
```

#### Test - Reopen PR 
**Not TESTABLE Via Act Currently See This Issue: https://github.com/nektos/act/issues/671**
```bash
act pull_request --secret-file ./cicd-test/my.secrets -e ./cicd-test/events/pr-reopen.json --reuse
```

#### Test - Synchronize PR 
**Not TESTABLE Via Act Currently See This Issue: https://github.com/nektos/act/issues/671**
```bash
act pull_request --secret-file ./cicd-test/my.secrets -e ./cicd-test/events/pr-sync.json --reuse
```

#### Test - Close PR (Workflow Should Not Run)
**Not TESTABLE Via Act Currently See This Issue: https://github.com/nektos/act/issues/671**
```bash
act pull_request --secret-file ./cicd-test/my.secrets -e ./cicd-test/events/pr-close.json --reuse
```

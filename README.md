# Common #

A package of common controllers, concerns & authentication for the [React/Rails Shopify app](https://github.com/pemberton-rank/react-shopify-app). Used in production by the 100k user app: [Plug in SEO](https://apps.shopify.com/plug-in-seo).

### How to use ###

Reference the repo and a specific version in your Gemfile like this:

``` gem 'pr-common', git: 'https://github.com/pemberton-rank/common.git', tag: 'v0.0.5' ```

#### Development ####
If you're developing a project X, changing pr-common and want to use your local version:

* build ```gem build pr-common.gemspec```
* install ```gem install pr-common-x.x.x.gem```
* update project X Gemfile with ```gem 'pr-common', path: '../common'```
* run ```bundle install```
* run project X as normal

### Versioning ###

A numbered version is created when your common pull request is approved and the branch is merged into master.

The development process is:

* create a branch of common
* create a branch of project X (the project which references common)
* work on your local common as in 'Development' above, and project X
* when you are finished with all of the work needed for common, create a pull request for it
* when that pull request is approved and merged an admin of common will:
  * update lib/pr/common/version.rb file with current version
  * run ```gem build pr-common.gemspec```
  * commit and push to master
  * tag this release on master with the version like ```git tag v0.2.0```
  * push this tag ```git push origin master --tags```
* edit the project X Gemfile with ```gem 'pr-common', git: 'https://github.com/pemberton-rank/common.git', tag: 'v0.2.0'```
* create a pull request for project X

If there are issues with common discovered in testing project X you will have to create a new branch and version.


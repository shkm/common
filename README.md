# Common #

A package of common controllers, concerns & authentication for the [React/Rails Shopify app](https://github.com/pemberton-rank/react-shopify-app). Used in production by the 100k user app: [Plug in SEO](https://apps.shopify.com/plug-in-seo).

### How to use ###

Reference the repo and a specific version in your Gemfile like this:

``` gem 'pr-common', git: 'https://github.com/pemberton-rank/common.git', tag: 'v0.0.5' ```

#### Local dev ####
If you're developing a project X, changing pr-common and want to use your local version:

* build ```gem build pr-common.gemspec```
* install ```gem install pr-common-x.x.x.gem```
* update project X Gemfile with ```gem 'pr-common', path: '../common'```
* run ```bundle install```
* run project X as normal

### Versioning ###

* update lib/pr/common/version.rb file with current version
* commit changes
* add tag ```git tag v1.x.x```
* push on server ```git push origin master --tags```

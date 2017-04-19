# pr-common #

A package of common controllers, concerns & authentication. Things that will be used in every app we create. So far, Blimpon and Plug in SEO v3 use it.

### How to use ###

Reference the repo and a specific version in your Gemfile like this:

``` gem 'pr-common', git: 'git@bitbucket.org:pembertonrank/common.git', tag: 'v0.0.5' ```

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
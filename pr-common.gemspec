$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'pr/common/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pr-common"
  s.version     = PR::Common::VERSION
  s.licenses    = ['MIT']
  s.authors     = ["Pemberton Rank Ltd"]
  s.email       = ["hello@pembertonrank.com"]
  s.homepage    = "https://www.pembertonrank.com"
  s.summary     = "Common components for the React/Rails Shopify app"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  # s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'rails'#, '~> 4.2', '> 4.2.3'
  s.add_dependency 'active_model_serializers'
  s.add_dependency 'nokogiri', '>= 1.8.2'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
end

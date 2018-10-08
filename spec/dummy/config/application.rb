require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require "pr/common"

module Dummy
  class Application < Rails::Application
    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true

    # Throws an error unless this is set
    Rails.application.config.active_job.queue_adapter = :sidekiq
  end
end


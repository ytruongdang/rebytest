require_relative "boot"

require "rails/all"

Bundler.require *Rails.groups

module Fbt5
  class Application < Rails::Application
    config.middleware.use I18n::JS::Middleware
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.generators do |g|
      g.factory_girl false
    end
  end
end

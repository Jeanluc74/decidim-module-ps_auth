# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/ps_auth/action_authorizer_overrides"

module Decidim
  module PsAuth
    # This is the engine that runs on the public interface of ps_auth.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::PsAuth

      routes do
        # Add engine routes here
        root to: "authorizations#new"
      end

      initializer "ps_auth.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_my_module.action_authorizer_patch" do
        config.to_prepare do
          Decidim::ActionAuthorizer.prepend(Decidim::PsAuth::ActionAuthorizerOverrides)
        end
      end

    end
  end
end

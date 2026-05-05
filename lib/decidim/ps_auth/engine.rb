# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/ps_auth/action_authorizer_overrides"
require "decidim/ps_auth/resource_permissions_overrides"
require "decidim/ps_auth/onboarding_manager_overrides"

module Decidim
  module PsAuth
    # This is the engine that runs on the public interface of ps_auth.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::PsAuth

      routes do
        root to: "authorizations#new"
      end

      initializer "ps_auth.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "ps_auth.action_authorizer_patch" do
        config.to_prepare do
          Decidim::ActionAuthorizer.prepend(Decidim::PsAuth::ActionAuthorizerOverrides)
          Decidim::Admin::ResourcePermissionsController.include(Decidim::PsAuth::ResourcePermissionsOverrides)
          Decidim::OnboardingManager.include(Decidim::PsAuth::OnboardingManagerOverrides)
        end
      end

    end
  end
end

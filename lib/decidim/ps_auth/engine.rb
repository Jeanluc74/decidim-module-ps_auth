# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module PsAuth
    # This is the engine that runs on the public interface of ps_auth.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::PsAuth

      routes do
        # Add engine routes here
        root to: "ps_auth#index"
      end

      initializer "ps_auth.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end

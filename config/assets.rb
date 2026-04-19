# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_ps_auth: "#{base_path}/app/packs/entrypoints/decidim_ps_auth.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/ps_auth/ps_auth")

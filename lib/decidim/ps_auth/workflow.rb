# frozen_string_literal: true

Decidim::Verifications.register_workflow(:ps_auth) do |workflow|
  workflow.engine = Decidim::PsAuth::Engine
  workflow.admin_engine = Decidim::PsAuth::AdminEngine
  workflow.action_authorizer = Decidim::PsAuth::ActionAuthorizer
  workflow.icon = "community-line"
end

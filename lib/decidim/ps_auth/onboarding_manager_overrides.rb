# frozen_string_literal: true

module Decidim
  module PsAuth
    module OnboardingManagerOverrides

      extend ActiveSupport::Concern

      included do
        def authorization_handlers
          return [] unless permissions

          ps = permissions_holder&.participatory_space || component&.participatory_space
          available_authorizations = component.organization.available_authorizations
          my_permissions = action == "vote" && Decidim::PsAuth::Setting.active_permissions(component.organization, ps).present? && available_authorizations.include?("ps_auth") ? ["ps_auth"] : []
          (permissions["authorization_handlers"]&.keys&.map(&:to_s) || []).concat(my_permissions)
        end

      end
    end
  end
end
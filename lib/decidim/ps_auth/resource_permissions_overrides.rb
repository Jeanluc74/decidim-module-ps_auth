# frozen_string_literal: true

module Decidim
  module PsAuth
    module ResourcePermissionsOverrides
      extend ActiveSupport::Concern

      included do
        private

        def authorizations
          Verifications::Adapter.from_collection(
            current_organization.available_authorizations.reject { |a| a == "ps_auth" }
          )
        end
      end
    end
  end
end


# frozen_string_literal: true

module Decidim
  module PsAuth
    class ConfirmPsAuthAuthorization < Verifications::ConfirmUserAuthorization
      def call
        return broadcast(:invalid) unless form.valid?

        if confirmation_successful?
          authorization.grant!

          @form.active_settings.each do |setting|
            Decidim::PsAuth::AuthorizationSetting.create(authorization: , setting: ,user: @form.user)
          end
          broadcast(:ok)
        else
          broadcast(:invalid)
        end
      end
    end
  end
end

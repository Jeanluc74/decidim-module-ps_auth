# frozen_string_literal: true

module Decidim
  module PsAuth
    class AuthorizationsController < Decidim::ApplicationController
      helper_method :authorization

      before_action :load_authorization

      def new
        @form = PsAuthForm.from_params(user: current_user)
        ConfirmPsAuthAuthorization.call(@authorization, @form, session) do
          on(:ok) do
            flash[:notice] = t("authorizations.new.success", scope: "decidim.ps_auth")
          end
          on(:invalid) do
            flash[:alert] = t("authorizations.new.error", scope: "decidim.ps_auth")
          end
          redirect_to decidim_verifications.authorizations_path
        end
      end

      private

      def load_authorization
        @authorization = Decidim::Authorization.find_or_initialize_by(
          user: current_user,
          name: "ps_auth"
        )
      end
    end
  end
end

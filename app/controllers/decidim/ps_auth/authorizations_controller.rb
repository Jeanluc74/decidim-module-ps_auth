# frozen_string_literal: true

module Decidim
  module PsAuth
    class AuthorizationsController < Decidim::Verifications::ApplicationController
      helper_method :authorization

      before_action :load_authorization

      def new
        current_cf = Decidim::PsAuth.call_cf_lookup(current_organization, current_user&.id)
        @form = PsAuthForm.from_params(user: current_user).with_context(
          current_organization: current_organization,
          current_user: current_user,
          current_participatory_space: current_participatory_space,
          current_cf: current_cf,
          active_settings: Setting.active.search_cf(current_organization, current_cf, current_participatory_space)
        )
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

      def current_participatory_space
        @current_participatory_space ||= Decidim::Component.find_by(id: params[:component_id])&.participatory_space
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

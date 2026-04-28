module Decidim
  module PsAuth
    class ActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer

      def authorize

        settings = Decidim::PsAuth::Setting.active_permissions(component.organization, component.participatory_space)
        if settings.present? && options["action"] == "vote"
          active_setting = settings.for_user(Decidim::PsAuth.call_cf_lookup(component.organization, options["user_id"]))
          status_code, data = if active_setting.present? && Decidim::Authorization.find_by(decidim_user_id: options["user_id"], name: "ps_auth")&.granted?
            [:ok, {}]
          else
            [:missing, { action: :authorize }]
          end
        else
          status_code, data = *super
        end

        [status_code, data]
      end

      def redirect_params
        { component_id: component&.id }
      end

    end
  end
end
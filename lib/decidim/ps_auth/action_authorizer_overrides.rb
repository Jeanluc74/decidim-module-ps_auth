module Decidim
  module PsAuth
    module ActionAuthorizerOverrides
      private

      def authorization_handlers
        available_authorizations = component.organization.available_authorizations

        my_permissions =
          if action == "vote" &&
             Decidim::PsAuth::Setting.active_permissions(
               component.organization,
               component.participatory_space
             ).present? &&
             available_authorizations.include?("ps_auth")

            { "ps_auth" => { "options" => { user_id: user&.id, action: action } } }
          else
            {}
          end

        if permission&.has_key?("authorization_handler_name") &&
           available_authorizations.include?(permission["authorization_handler_name"])

          options = permission["options"]

          b = {
            permission["authorization_handler_name"] =>
              options.present? ? { "options" => options } : {}
          }

        else
          b = permission
                &.fetch("authorization_handlers", {})
                &.slice(*available_authorizations)
        end

        b.blank? ? my_permissions : b.merge(my_permissions)
      end
    end
  end
end
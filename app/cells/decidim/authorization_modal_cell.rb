require_dependency Decidim::Core::Engine.root.join('app', 'cells', 'decidim', 'authorization_modal_cell').to_s

module Decidim
  class AuthorizationModalCell

    delegate :current_component, to: :controller


    def status_cta(status)
      if status.data[:action].present?
        uri = URI(authorize_action_path(status.handler_name))
        uri.query = uri.query.to_s
                       .then { |q| Rack::Utils.parse_query(q) }
                       .merge(component_id: controller.send(:current_component).id)
                       .to_query

        {
          type: :a,
          text: t(
            "#{status.code}.#{status.data[:action]}",
            authorization: t("#{status.handler_name}.name", scope: "decidim.authorization_handlers"),
            scope:
          ),
          url: uri.to_s
        }
      else
        {
          type: :button,
          text: t("#{status.code}.ok", scope:),
          data: { "dialog-close": "authorizationModal" }
        }
      end
    end

  end
end
module Decidim::PsAuth::Admin::SettingsHelper
  def render_authorizables(setting)
    setting.authorizables.map do |auth|
      resource = auth.resource
      next unless resource

      label = case auth.resource_type
              when "Decidim::ParticipatoryProcess"
                t("decidim.ps_auth.authorizables.process")
              when "Decidim::Assembly"
                t("decidim.ps_auth.authorizables.assembly")
              when "Decidim::Initiative"
                t("decidim.ps_auth.authorizables.initiative")
              else
                auth.resource_type
              end

      "#{label}: #{translated_attribute(resource.title)}"
    end.compact.join("<br>").html_safe
  end
end
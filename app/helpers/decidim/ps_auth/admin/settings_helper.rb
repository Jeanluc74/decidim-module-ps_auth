module Decidim::PsAuth::Admin::SettingsHelper
  def render_resource(setting)
    resource = setting.resource

    label = case setting.resource_type
            when "Decidim::ParticipatoryProcess"
              t("decidim.ps_auth.admin.settings.index.process")
            when "Decidim::Assembly"
              t("decidim.ps_auth.admin.settings.index.assembly")
            when "Decidim::Initiative"
              t("decidim.ps_auth.admin.settings.index.initiative")
            else
              setting.resource_type
            end

    "#{label}: #{translated_attribute(resource.title)}"
  end
end
module Decidim::PsAuth
  class Setting < ApplicationRecord
    belongs_to :organization, foreign_key: :decidim_organization_id,
               class_name: "Decidim::Organization"
    belongs_to :resource, polymorphic: true

    has_many :authorization_settings, class_name: "Decidim::PsAuth::AuthorizationSetting",
             foreign_key: :decidim_ps_auth_setting_id, dependent: :destroy

    scope :active, -> { where(active: true) }
    scope :active_permissions, -> (o, ps) { active.where(organization: o, resource: ps ) }
    scope :for_user, -> (cf) { where("? = ANY(fiscal_codes)", cf) }

    def self.ransackable_attributes(_auth_object = nil)
      %w[id name created_at updated_at decidim_organization_id resource_type]
    end


    def self.search_cf(organization, cf, resource)
      query = where(organization: organization)
                .where("? = ANY(fiscal_codes)", cf)

      query = query.where(resource: resource) if resource.present?
      query
    end
  end
end

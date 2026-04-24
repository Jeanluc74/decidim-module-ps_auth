module Decidim::PsAuth
  class Setting < ApplicationRecord
    belongs_to :organization, foreign_key: :decidim_organization_id,
               class_name: "Decidim::Organization"

    has_many :authorizables, class_name: "Decidim::PsAuth::Authorizable", dependent: :destroy

    scope :active, -> { where(active: true) }
    scope :active_permissions, -> (o, ps) { active.includes(:authorizables).where(organization: o, authorizables: { resource: ps }) }
    scope :for_user, -> (cf) { where("? = ANY(fiscal_codes)", cf) }

    def resources
      authorizables.includes(:resource).map(&:resource).compact
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id name created_at updated_at decidim_organization_id]
    end


    def self.search_cf(organization, cf, resource)
      query = includes(:authorizables)
                .where(organization: organization)
                .where("? = ANY(fiscal_codes)", cf)

      query = query.where(resource: resource) if resource.present?
      query
    end
  end
end

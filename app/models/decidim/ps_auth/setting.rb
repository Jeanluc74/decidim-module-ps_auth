module Decidim::PsAuth
  class Setting < ApplicationRecord
    belongs_to :organization, foreign_key: :decidim_organization_id,
               class_name: "Decidim::Organization"

    has_many :authorizables, class_name: "Decidim::PsAuth::Authorizable", dependent: :destroy

    def resources
      authorizables.includes(:resource).map(&:resource).compact
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id name created_at updated_at decidim_organization_id]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[authorizables]
    end
  end
end

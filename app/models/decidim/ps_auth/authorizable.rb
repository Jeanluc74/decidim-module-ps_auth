module Decidim::PsAuth
  class Authorizable < ApplicationRecord
    belongs_to :setting, class_name: "Decidim::PsAuth::Setting"
    belongs_to :resource, polymorphic: true

    #todo: verificare
    def self.ransackable_attributes(_auth_object = nil)
      %w[id setting_id resource_type resource_id created_at updated_at]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[setting resource]
    end
  end
end

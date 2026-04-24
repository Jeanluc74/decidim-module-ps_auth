module Decidim::PsAuth
  class Authorizable < ApplicationRecord
    belongs_to :setting, class_name: "Decidim::PsAuth::Setting"
    belongs_to :resource, polymorphic: true

  end
end

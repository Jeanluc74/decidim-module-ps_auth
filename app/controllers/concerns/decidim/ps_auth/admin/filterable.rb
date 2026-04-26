# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module PsAuth
    module Admin
      module Filterable
        extend ActiveSupport::Concern

        included do
          include Decidim::Admin::Filterable

          private

          def base_query
            collection
          end

          def search_field_predicate
            :name_cont
          end

          def filters
            [:resource_type_eq]
          end

          def filters_with_values
            {
              resource_type_eq: [
                "Decidim::ParticipatoryProcess",
                "Decidim::Assembly",
                "Decidim::Initiative"
              ]
            }
          end
        end
      end
    end
  end
end

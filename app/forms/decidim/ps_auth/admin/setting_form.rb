# frozen_string_literal: true

module Decidim
  module PsAuth
    module Admin
      class SettingForm < Form
        include Decidim::TranslationsHelper
        include ActiveModel::Validations::Callbacks

        before_validation :normalize_fiscal_codes_from_file

        attribute :file
        attribute :name
        attribute :resource
        attribute :fiscal_codes, Array[String]

        validates :name, :file, :resource, presence: true
        validate :unique_resource

        def authorizable_options(_s = nil)
          processes = Decidim::ParticipatoryProcess.where(organization: current_organization).map do |p|
            [
              "#{I18n.t('decidim.ps_auth.admin.settings.index.process')}: #{translated_attribute(p.title)}",
              "Decidim::ParticipatoryProcess-#{p.id}"
            ]
          end

          assemblies = Decidim::Assembly.where(organization: current_organization).map do |a|
            [
              "#{I18n.t('decidim.ps_auth.admin.settings.index.assembly')}: #{translated_attribute(a.title)}",
              "Decidim::Assembly-#{a.id}"
            ]
          end

          initiatives = []
          if (defined?(Decidim::Initiative))
            initiatives = Decidim::Initiative.where(organization: current_organization).map do |i|
              [
                "#{I18n.t('decidim.ps_auth.admin.settings.index.initiative')}: #{translated_attribute(i.title)}",
                "Decidim::Initiative-#{i.id}"
              ]
            end
          end

          processes + assemblies + initiatives
        end

        def authorizable_selected
          if self&.resource && self&.resource.is_a?(String)
            { selected: self&.resource }
          elsif self&.resource
            { selected: "#{self.resource.class.name}-#{self.resource.id}" }
          else
            {}
          end
        end

        def fiscal_codes_from_file
          Array(fiscal_codes)
        end

        def unique_resource
          resource_type, resource_id = resource.to_s.split("-", 2)
          return true if Decidim::PsAuth::Setting.where(organization: context.current_organization.id, resource_type: resource_type, resource_id: resource_id).where.not(id: self.id).empty?

          errors.add :resource, :taken
          false
        end

        private

        def normalize_fiscal_codes_from_file
          return unless file.respond_to?(:path) && file.path.present?

          self.fiscal_codes = CSV.read(file.path)
                                 .flatten
                                 .map { |value| value.to_s.upcase.strip }
                                 .reject(&:blank?)
                                 .uniq
        rescue CSV::MalformedCSVError
          errors.add(:file, :malformed)
          self.fiscal_codes = []
        end
      end
    end
  end
end

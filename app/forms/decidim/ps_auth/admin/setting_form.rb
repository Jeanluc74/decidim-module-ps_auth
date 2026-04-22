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
        attribute :authorizables, Array[String]
        attribute :fiscal_codes, Array[String]

        validates :name, :file, :authorizables, presence: true

        def authorizable_options(_s = nil)
          processes = Decidim::ParticipatoryProcess.where(organization: current_organization).map do |p|
            [
              "#{I18n.t('decidim.ps_auth.authorizables.process')}: #{translated_attribute(p.title)}",
              "Decidim::ParticipatoryProcess-#{p.id}"
            ]
          end

          assemblies = Decidim::Assembly.where(organization: current_organization).map do |a|
            [
              "#{I18n.t('decidim.ps_auth.authorizables.assembly')}: #{translated_attribute(a.title)}",
              "Decidim::Assembly-#{a.id}"
            ]
          end

          initiatives = Decidim::Initiative.where(organization: current_organization).map do |i|
            [
              "#{I18n.t('decidim.ps_auth.authorizables.initiative')}: #{translated_attribute(i.title)}",
              "Decidim::Initiative-#{i.id}"
            ]
          end

          processes + assemblies + initiatives
        end

        def selected_keys(s)
          return {} unless s

          selected = s.resources.filter_map do |value|
            if value.is_a?(String)
              value
            elsif value.respond_to?(:id) && value.id.present?
              "#{value.class.name}-#{value.id}"
            end
          end

          { selected: selected }
        end

        def fiscal_codes_from_file
          Array(fiscal_codes)
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

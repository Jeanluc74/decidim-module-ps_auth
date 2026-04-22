# frozen_string_literal: true

module Decidim
  module PsAuth
    module Admin
      # A command with the business logic to create census data for a
      # organization.
      class SaveSetting < Decidim::Command
        def initialize(form, organization)
          @form = form
          @organization = organization
        end

        # Executes the command. Broadcast this events:
        # - :ok when everything is valid
        # - :invalid when the form was not valid and could not proceed-
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if @form.invalid?

          ActiveRecord::Base.transaction do
            setting = find_or_initialize_setting
            setting.name = @form.name
            setting.fiscal_codes = @form.fiscal_codes_from_file
            setting.save!

            update_authorizables!(setting)
          end

          broadcast(:ok)
        rescue ActiveRecord::RecordInvalid
          broadcast(:invalid)
        end

        private

        def find_or_initialize_setting
          form_id = @form.respond_to?(:id) ? @form.id : nil

          if form_id.present?
            Decidim::PsAuth::Setting.find_or_initialize_by(id: form_id, organization: @organization)
          else
            Decidim::PsAuth::Setting.find_or_initialize_by(organization: @organization, name: @form.name)
          end
        end

        def update_authorizables!(setting)
          values = Array(@form.authorizables).reject(&:blank?)

          records = values.filter_map do |value|
            type, id = value.to_s.split("-", 2)
            next if type.blank? || id.blank?

            { resource_type: type, resource_id: id }
          end.uniq

          # TODO: cambiare approccio
          setting.authorizables.destroy_all
          records.each { |attrs| setting.authorizables.create!(attrs) }
        end
      end
    end
  end
end

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
            resource_type, resource_id = @form.resource.to_s.split("-", 2)
            setting.resource_type = resource_type
            setting.resource_id = resource_id
            setting.save!

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

      end
    end
  end
end

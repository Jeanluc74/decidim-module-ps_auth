# frozen_string_literal: true

module Decidim
  module PsAuth
      class PsAuthForm < AuthorizationHandler
        validate :authorized
        validate :cf_presence

        delegate :active_settings, :current_cf, to: :context

        def authorized?
          true if user_present?
        end

        private

        def authorized
          return if user_present?
          errors.add(:email, I18n.t("decidim.ps_auth.authorizations.new.error"))
        end

        def cf_presence
          return if current_cf.present?
          errors.add(:email, I18n.t("decidim.ps_auth.authorizations.new.error"))
        end

        def organization
          current_organization || user.organization
        end

        def user_present?
          active_settings.present?
        end

        def unique_id
          Digest::MD5.hexdigest(
            "#{handler_name}-#{current_cf}-#{Rails.application.secrets.secret_key_base}"
          )
        end
      end
    end
  end

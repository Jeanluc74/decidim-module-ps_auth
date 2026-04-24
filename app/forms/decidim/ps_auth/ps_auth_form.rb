# frozen_string_literal: true

module Decidim
  module PsAuth
      class PsAuthForm < AuthorizationHandler
        validate :authorized

        def authorized?
          true if user_present?
        end

        private

        def authorized
          return if user_present?

          errors.add(:email, I18n.t("decidim.ps_auth.authorizations.new.error"))
        end

        def organization
          current_organization || user.organization
        end

        def user_present?
          Setting.search_cf(organization, Decidim::PsAuth.call_cf_lookup(organization, user&.id), nil).present?
        end
      end
    end
  end

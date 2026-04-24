# frozen_string_literal: true

Decidim::PsAuth.configure do |config|

  config.cf_lookup = -> (organization, user_id) {
    # organization può essere usata per differenziare i processi di lookup in base al tenant
    # Esempi:
    # Decidim::User.find_by(user_id: user_id, organization: organization)&.fiscal_code
    # Decidim::Authorization.find_by(decidim_user_id: organization.users.find_by(id: user_id))&.metadata&.try(:[], "fiscal_code")
  }
end
module Decidim::PsAuth
  class AuthorizationSetting < ApplicationRecord

    belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"
    belongs_to :authorization, foreign_key: "decidim_authorization_id", class_name: "Decidim::Authorization"
    belongs_to :setting, foreign_key: "decidim_ps_auth_setting_id", class_name: "Decidim::PsAuth::Setting"

    before_destroy :destroy_authorization_if_last!

    private

    # Distrugge Decidim::Authorization solo se questo è l'unico AuthorizationSetting
    # collegato a quell'utente. Se l'utente ha altre autorizzazioni attive su
    # altri setting, Decidim::Authorization viene conservato.
    def destroy_authorization_if_last!
      # todo: verificare
      other_authorization_users = AuthorizationSetting
        .where(decidim_user_id: decidim_user_id)
        .where.not(id: id)

      authorization&.destroy if other_authorization_users.none?
    end
  end
end

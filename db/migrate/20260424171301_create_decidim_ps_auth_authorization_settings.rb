class CreateDecidimPsAuthAuthorizationSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_ps_auth_authorization_settings do |t|
      t.references :decidim_authorization, null: false, index: { name: "index_decidim_ps_auth_au_on_decidim_authorization_id" }
      t.references :decidim_user, null: false, foreign_key: true, index: { name: "index_decidim_ps_auth_au_on_decidim_user_id" }
      t.references :decidim_ps_auth_setting, null: false, foreign_key: true, index: { name: "index_decidim_ps_auth_au_on_ps_auth_setting_id" }
      t.timestamps
    end
  end
end

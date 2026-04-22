class CreateDecidimPsAuthAuthorizables < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_ps_auth_authorizables do |t|
      t.references :setting, null: false, foreign_key: { to_table: :decidim_ps_auth_settings }, index: { name: "decidim_ps_auth_authorizable_setting" }
      t.references :resource, polymorphic: true, index: { name: "decidim_ps_auth_authorizable_resource" }
      t.timestamps
    end
  end
end

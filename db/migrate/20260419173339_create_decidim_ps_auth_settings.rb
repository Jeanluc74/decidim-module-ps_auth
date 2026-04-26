class CreateDecidimPsAuthSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_ps_auth_settings do |t|
      t.string :name, null: false
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_ps_auth_setting_decidim_organization" }
      t.references :resource, polymorphic: true, index: { name: "decidim_ps_auth_setting_resource" }
      t.string :fiscal_codes, array: true, default: []
      t.boolean :active, default: false
      t.timestamps
    end
  end

end

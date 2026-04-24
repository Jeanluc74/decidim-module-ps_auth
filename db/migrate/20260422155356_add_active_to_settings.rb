class AddActiveToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_ps_auth_settings, :active, :boolean, default: false
  end
end

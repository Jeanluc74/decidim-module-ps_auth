module Decidim
  module PsAuth
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)
        desc "This generator installs initializer to define CF lookup"

        def copy_initializer
          template "decidim-ps_auth.rb", "config/initializers/decidim-ps_auth.rb"
        end
      end
    end
  end
end
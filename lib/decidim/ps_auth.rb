# frozen_string_literal: true

require "decidim/ps_auth/admin"
require "decidim/ps_auth/engine"
require "decidim/ps_auth/admin_engine"
require "decidim/ps_auth/action_authorizer"
require "decidim/ps_auth/workflow"

module Decidim
  # This namespace holds the logic of the `PsAuth` component. This component
  # allows users to create ps_auth in a participatory space.
  module PsAuth
    include ActiveSupport::Configurable
    config_accessor :cf_lookup

    def self.call_cf_lookup(organization, user_id)
      config.cf_lookup&.call(organization, user_id)
    end
  end
end

# frozen_string_literal: true

module Decidim
  module PsAuth
    # This is the engine that runs on the public interface of `PsAuth`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::PsAuth::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        resources :settings do
          member do
            get :cfs_list
            get :active
            get :deactive
          end
        end
        root to: "settings#index"
      end

      def load_seed
        nil
      end
    end
  end
end

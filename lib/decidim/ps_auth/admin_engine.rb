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
        # resources :ps_auth do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "ps_auth#index"
      end

      def load_seed
        nil
      end
    end
  end
end

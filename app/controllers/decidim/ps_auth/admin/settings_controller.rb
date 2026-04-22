# frozen_string_literal: true

module Decidim
  module PsAuth
    module Admin
      class SettingsController < Decidim::Admin::ApplicationController
        include Decidim::PsAuth::Admin::Filterable

        layout "decidim/admin/users"

        before_action :load_setting, only: [:show, :edit, :update, :destroy, :cfs_list]

        # todo: verificare
        # include Decidim::Admin::WorkflowsBreadcrumb
        #add_breadcrumb_item_from_menu :workflows_menu

        def index
          enforce_permission_to :index, :authorization
          @settings = filtered_collection
        end

        def new
          enforce_permission_to :index, :authorization
          @form = form(SettingForm).instance
        end

        def create
          enforce_permission_to :create, :authorization
          @form = form(SettingForm).from_params(params)
          SaveSetting.call(@form, current_organization) do
            on(:ok) do
              flash[:notice] = t(".success")
              redirect_to settings_path
            end

            on(:invalid) do
              flash[:alert] = t(".error")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :index, :authorization
          @form = form(SettingForm).from_model(@setting)
        end

        def update
          enforce_permission_to :update, :authorization
          @form = form(SettingForm).from_params(params)
          SaveSetting.call(@form, current_organization) do
            on(:ok) do
              flash[:notice] = t(".success")
              redirect_to settings_path
            end

            on(:invalid) do
              flash[:alert] = t(".error")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :authorization
          @setting.destroy

          redirect_to settings_path, notice: t(".success")
        end

        def cfs_list
          enforce_permission_to :index, :authorization
          return head(:not_found) unless @setting

          @fiscal_codes = Array(@setting.fiscal_codes)
                          .compact
                          .map(&:to_s)
                          .reject(&:blank?)
                          .uniq
                          .sort

          respond_to do |format|
            format.html { render :cfs_list, layout: false }
            format.json { render json: { fiscal_codes: @fiscal_codes } }
          end
        end

        private

        def load_setting
          @setting ||= Decidim::PsAuth::Setting.find_by(id: params[:id], decidim_organization_id: current_organization.id)
        end

        def collection
          @collection ||= Decidim::PsAuth::Setting.where(organization: current_organization)
        end

      end
    end
  end
end

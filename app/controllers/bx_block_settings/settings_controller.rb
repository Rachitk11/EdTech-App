module BxBlockSettings
  class SettingsController < ApplicationController
    def index
      settings = Setting.all
      render json: { settings: settings, message: 'Successfully loaded' }
    end
  end
end

module BxBlockContentManagement
  class ContentProvidersController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]
  end
end

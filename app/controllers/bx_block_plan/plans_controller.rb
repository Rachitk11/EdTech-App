# frozen_string_literal: true

module BxBlockPlan
  class PlansController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, except: [:index]

    def index
      plans = BxBlockPlan::Plan.all
      if plans.present?
        render json: { plans: plans, message: 'Successfully Loaded' }
      else
        render json: { data: [] },
               status: :ok
      end
    end
  end
end

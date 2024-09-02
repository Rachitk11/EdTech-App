# frozen_string_literal: true

module BxBlockCategories
  class CtaController < ApplicationController
    before_action :assign_cta, only: [:index]
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      filter_cta
      @ctas = @ctas.page(params[:page]).per(params[:per_page])
      render json: CtaSerializer.new(@ctas).serializable_hash, status: :ok
    end

    private

    def assign_cta
      @ctas = Cta.includes(:category)
    end

    def filter_cta
      params.each do |key, value|
        case key
        when "category"
          @ctas = @ctas.where(categories: {id: value})
        when "visible_on_details_page"
          @ctas = @ctas.where(visible_on_details_page: true)
        when "visible_on_home_page"
          @ctas = @ctas.where(visible_on_home_page: true)
        end
      end
    end
  end
end

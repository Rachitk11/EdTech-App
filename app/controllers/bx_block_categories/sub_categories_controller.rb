# frozen_string_literal: true

module BxBlockCategories
  class SubCategoriesController < ApplicationController
    before_action :load_sub_category, only: %i[show update destroy]

    def create
      categories = Category.where(id: params[:parent_categories])
      category_ids = categories.map(&:id)

      return render json: {errors: "Category ID #{(params[:parent_categories].map(&:to_i) - category_ids).join(",")} not found"}, status: :not_found unless category_ids.count == params[:parent_categories].count

      sub_category = SubCategory.new(name: params[:sub_category][:name])
      if params[:parent_categories].present?
        sub_category.categories << Category.where(
          id: params[:parent_categories]
        )
      end
      if sub_category.valid?
        sub_category.save

        render json: SubCategorySerializer.new(
          sub_category,
          serialization_options
        ).serializable_hash,
          status: :created
      else
        render json: ErrorSerializer.new(sub_category).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def show
      return if @sub_category.nil?

      render json: SubCategorySerializer.new(@sub_category).serializable_hash,
        status: :ok
    end

    def index
      return render json: {message: "No data is present"}, status: :not_found unless SubCategory.all.present?
      serializer = if params[:category_id].present?
        sub_categories = Category.find(params[:category_id])
          .sub_categories
        SubCategorySerializer.new(sub_categories)
      else
        SubCategorySerializer.new(
          SubCategory.all,
          serialization_options
        )
      end

      render json: serializer, status: :ok
    end

    def destroy
      return if @sub_category.nil?

      begin
        render json: {message: "sub category deleted successfully"}, status: :ok if @sub_category.destroy
      rescue ActiveRecord::InvalidForeignKey
        message = "Record can't be deleted due to reference to catalogue"

        render json: {
          error: {message: message}
        }, status: :internal_server_error
      end
    end

    def update
      return if @sub_category.nil?

      update_result = @sub_category.update(name: params[:sub_category][:name])

      if update_result
        render json: SubCategorySerializer.new(@sub_category).serializable_hash,
          status: :ok
      else
        render json: ErrorSerializer.new(@sub_category).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def update_user_sub_categories
      sub_categories = SubCategory.where(id: params[:sub_categories_ids])
      sub_category_ids = sub_categories.map(&:id)

      return render json: {errors: "Sub Category ID #{(params[:sub_categories_ids].map(&:to_i) - sub_category_ids).join(",")} not found"}, status: :not_found unless sub_category_ids.count == params[:sub_categories_ids].count
      if sub_categories.present?
        UserSubCategory.where(account_id: current_user.id).delete_all
        params[:sub_categories_ids].each do |sub_cat_id|
          UserSubCategory.create!(account_id: current_user.id, sub_category_id: sub_cat_id)
        end
        sub_categories = SubCategory.joins(:user_sub_categories).where(user_sub_categories: {account_id: current_user.id})
        render json: SubCategorySerializer.new(sub_categories).serializable_hash,
          status: :ok
      end
    end

    private

    def load_sub_category
      @sub_category = SubCategory.find_by(id: params[:id])

      if @sub_category.nil?
        render json: {
          message: "SubCategory with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def serialization_options
      {}
      # options[:params] = {categories: true}
    end
  end
end

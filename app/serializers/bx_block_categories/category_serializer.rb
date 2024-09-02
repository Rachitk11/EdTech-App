# frozen_string_literal: true

module BxBlockCategories
  class CategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :dark_icon, :dark_icon_active, :dark_icon_inactive, :light_icon,
      :light_icon_active, :light_icon_inactive, :rank, :created_at, :updated_at

    attribute :sub_categories, if: proc { |_record, params|
      params && params[:sub_categories] == true
    }

    attribute :selected_sub_categories do |object, params|
      object.sub_categories.where(id: params[:selected_sub_categories]) if params[:selected_sub_categories].present?
    end

    attribute :light_icon do |object|
      if object.light_icon.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.light_icon, only_path: true)
      end
    end

    attribute :light_icon_active do |object|
      if object.light_icon_active.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.light_icon_active, only_path: true)
      end
    end

    attribute :light_icon_inactive do |object|
      if object.light_icon_inactive.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.light_icon_inactive, only_path: true)
      end
    end

    attribute :dark_icon do |object|
      if object.dark_icon.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.dark_icon, only_path: true)
      end
    end

    attribute :dark_icon_active do |object|
      if object.dark_icon_active.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.dark_icon_active, only_path: true)
      end
    end

    attribute :dark_icon_inactive do |object|
      if object.dark_icon_inactive.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.dark_icon_inactive, only_path: true)
      end
    end
  end
end

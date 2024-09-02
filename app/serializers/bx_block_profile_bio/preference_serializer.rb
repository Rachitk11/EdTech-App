# frozen_string_literal: true

module BxBlockProfileBio
  # preference serializer
  class PreferenceSerializer < BuilderBase::BaseSerializer
    attributes(:account_id, :seeking, :location, :distance, :age_range_start,
               :age_range_end, :height_range_start, :height_range_end, :height_type,
               :body_type, :religion, :smoking, :drinking, :friend, :business,
               :match_making, :travel_partner, :cross_path, :created_at, :updated_at)
  end
end

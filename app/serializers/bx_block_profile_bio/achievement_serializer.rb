# frozen_string_literal: true

module BxBlockProfileBio
  # achiveemnt serializer
  class AchievementSerializer < BuilderBase::BaseSerializer
    attributes(:title, :achievement_date, :detail, :url, :profile_bio_id, :created_at, :updated_at)
  end
end

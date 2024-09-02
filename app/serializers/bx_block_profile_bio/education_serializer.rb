# frozen_string_literal: true

module BxBlockProfileBio
  # education serializer
  # BxBlockProfileBio module
  class EducationSerializer < BuilderBase::BaseSerializer
    attributes(:qualification, :profile_bio_id, :description, :created_at, :updated_at)

    attribute :education_from_to_end do |object|
      [object.year_from, object.year_to].join('-')
    end
  end
end

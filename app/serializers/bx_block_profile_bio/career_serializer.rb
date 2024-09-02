# frozen_string_literal: true

module BxBlockProfileBio
  # carrer serializer
  class CareerSerializer < BuilderBase::BaseSerializer
    attributes(:profession, :is_current, :payscale, :company_name, :accomplishment, :sector, :profile_bio_id,
               :created_at, :updated_at)

    attribute :career_from_to_end do |object|
      [object.experience_from, object.experience_to].join('-')
    end
  end
end

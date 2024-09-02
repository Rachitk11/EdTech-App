module BxBlockProfileBio
  # profile bio serializer
  class ProfileBioSerializer < BuilderBase::BaseSerializer
    attributes(:account_id, :height, :weight, :height_type, :weight_type, :body_type, :mother_tougue,
    :religion, :zodiac, :marital_status, :languages, :about_me, :personality, :interests, :smoking,
    :drinking, :custom_attributes, :looking_for,
      :created_at, :updated_at, :educations, :achievements, :careers, :account)
  end
end

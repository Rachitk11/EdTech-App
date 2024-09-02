module BxBlockLandingpage2
  class LandingpageSerializer < BuilderBase::BaseSerializer
    attribute :name do |acc|
      acc.try(:first_name)
    end

    attribute :student_id do |acc|
      acc.try(:student_unique_id)
    end

    attribute :class do |acc|
      acc&.class_division&.school_class&.class_number
    end

    attribute :division do |acc|
      acc&.class_division&.division_name
    end

    attribute :department do |acc|
      acc.class_division.department rescue nil
    end

    attribute :guardian_email do |acc|
      acc.try(:guardian_email)
    end

    attributes :photo do |object, params|
      if object.try(:profile).try(:photo).try(:attached?)
        host_url = params[:host] 
        host_url + Rails.application.routes.url_helpers.rails_blob_url(object.try(:profile).try(:photo), only_path: true, host: host_url)
      else
        ''
      end
    end
  end
end

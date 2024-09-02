module BxBlockLandingpage2
  class AccountSerializer < BuilderBase::BaseSerializer
    attribute :user_type do |acc|
      acc&.role.name
    end

    attribute :name do |acc|
      acc&.first_name
    end

    attribute :student_id do |acc|
      acc&.student_unique_id
    end

    attribute :teacher_id do |acc|
      acc&.teacher_unique_id
    end

    attribute :teacher_email do |acc|
      acc&.email
    end

    attribute :phone_number do |acc|
      acc&.full_phone_number
    end

    attribute :class do |acc|
      acc&.class_division&.school_class&.class_number
    end

    attribute :division do |acc|
      acc&.class_division&.division_name
    end

    attribute :department do |acc|
      acc&.class_division&.department rescue nil
    end

    attribute :guardian_email do |acc|
      acc&.guardian_email
    end

    attributes :subject do |object| 
      BxBlockCatalogue::Subject.find_by(account_id: object&.id).subject_name rescue nil
    end

    attribute :guardian_name do |acc|
      acc&.guardian_name
    end

    attributes :photo do |object, params|
      if object.profile&.photo&.attached?
        host = params[:host] || ''
        url = host + Rails.application.routes.url_helpers.rails_blob_url(object.profile.photo, only_path: true)
      else
        ''
      end
    end
  end
end

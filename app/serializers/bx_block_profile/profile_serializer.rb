module BxBlockProfile
  class ProfileSerializer < BuilderBase::BaseSerializer
    attributes(:email, :full_phone_number, :role, :name, :school_name,
               :publication_house_name, :guardian_email, :guardian_name,
               :guardian_contact_no, :teacher_unique_id, :student_unique_id)
    attribute :role do |object|
      object.account.role&.name rescue nil
    end

    attribute :name do |object|
      object.user_name rescue nil
    end

    attribute :school_name do |object|
      object.account.school&.name rescue nil
    end

    attribute :student_details do |object|
      BxBlockProfile::StudentProfileSerializer.new(object)
    end

    attribute :class_teacher do |object|
      teacher = AccountBlock::Account.find_by_id(object.account.class_division.account_id) rescue nil
      BxBlockProfile::TeacherProfileSerializer.new(teacher)
    end

    attribute :allocated_class do |object|
      class_division = BxBlockCategories::ClassDivision.where(account_id: object.account_id)
      BxBlockCategories::ClassAllocatedSerializer.new(class_division)
    end

    attributes :photo do |object|
      if object.photo.attached?
        host_url = Rails.application.routes.default_url_options[:host]
        Rails.application.routes.url_helpers.rails_blob_url(object.photo, only_path: true, host: host_url)
      else
        ''
      end
    end

    attributes :photo do |object, params|
      if object.photo.attached?
        # host_url = Rails.application.routes.default_url_options[:host]
        host = params[:host] || ''
        url = host + Rails.application.routes.url_helpers.rails_blob_url(object.photo, only_path: true)
      else
        ''
      end
    end
  end
end

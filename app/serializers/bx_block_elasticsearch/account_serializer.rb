module BxBlockElasticsearch
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
      acc.class_division.department rescue nil
    end

    attribute :guardian_email do |acc|
      acc&.guardian_email
    end

    attribute :guardian_name do |acc|
      acc&.guardian_name
    end
  end
end

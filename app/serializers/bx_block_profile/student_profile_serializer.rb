module BxBlockProfile
  class StudentProfileSerializer < BuilderBase::BaseSerializer

    attribute :account_id do |object|
      object.account_id
    end

    attribute :class do |object|
      BxBlockCategories::SchoolClass.find_by_id(object.account.school_class_id).class_number rescue nil
    end

    attribute :division do |object|
      AccountBlock::Account.find(object.account_id).class_division.division_name rescue nil 
    end

    # attribute :department do |object|
    #   AccountBlock::Account.find(object.account_id).class_division.department rescue nil
    # end
  end
end
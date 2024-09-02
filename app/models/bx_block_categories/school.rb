module BxBlockCategories
  class School < ApplicationRecord
    self.table_name = :schools
    EMAIL_REGEX = /\w+@\w+.{1}[a-zA-Z]{2,}/

    has_many :accounts, class_name: "AccountBlock::Account", foreign_key: "school_id", dependent: :destroy
    has_many :school_classes, class_name: "BxBlockCategories::SchoolClass", dependent: :destroy 

    validates_presence_of :name, :email, :board, :phone_number, :principal_name
    validates_format_of :email, with: EMAIL_REGEX
    validates_uniqueness_of :email, :name
    validates_length_of :phone_number, is: 10, numericality: { only_integer: true }

    before_destroy :delete_accounts

    # before_validation :valid_phone_number
    # has_many :departments, class_name: "BxBlockCategories::Department", dependent: :destroy 
    # has_many :class_divisions, class_name: "BxBlockCategories::ClassDivision", dependent: :destroy 

    private
    
      def delete_accounts
        self.accounts.each do |account|
          account.delete
        end
      end

      def valid_phone_number
        unless Phonelib.valid?(phone_number)
          errors.add(:phone_number, "Invalid or Unrecognized Phone Number")
        end
      end
  end
end

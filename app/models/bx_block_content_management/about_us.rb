module BxBlockContentManagement
  class AboutUs < ApplicationRecord
    self.table_name = :about_us
    EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    PHONE_NUMBER_REGEX = /\A\d{10}\z/
    #PHONE_NUMBER_REGEX = /\A\+\d{1,3}\s\d+\z/
    # Validations
    validate :only_one_entry_allowed
    validates :title, :email, :phone_number, presence: true
    validates :email, format: { with: EMAIL_REGEX }
    validates :phone_number, presence: true, format: { with: PHONE_NUMBER_REGEX }

    def only_one_entry_allowed
      if AboutUs.exists? && !self.persisted?
        errors.add(:base, 'Only one entry is allowed, please delete the existing one to create a new entry.')
      end
    end
  end
end
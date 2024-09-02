module BxBlockTermsAndConditions
  class TermsAndCondition < ApplicationRecord
    has_many :user_terms_and_conditions,
      class_name: "BxBlockTermsAndConditions::UserTermAndCondition",
      dependent: :destroy, foreign_key: :terms_and_condition_id
    has_many :accounts, through: :user_terms_and_conditions
    validates :name, presence: true  
    validates :description, presence: true, length: { maximum: 5000 }
    validate :only_one_entry_allowed

    def get_accepted_accounts
      BxBlockTermsAndConditions::UserTermAndCondition
        .joins(:account)
        .select("accounts.*,bx_block_terms_and_conditions_user_term_and_conditions.*")
        .where(terms_and_condition_id: id, is_accepted: true)
    end

    def only_one_entry_allowed
      if BxBlockTermsAndConditions::TermsAndCondition.exists? && !self.persisted?
        errors.add(:base, 'Only one entry is allowed, please delete the existing one to create a new entry.')
      end
    end

    class << self
      private

      def self.image_url(image)
        if image.attached?
          if Rails.env.development? || Rails.env.test?
            Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
          else
            image.service_url&.split("?")&.first
          end
        end
      end
    end
  end
end

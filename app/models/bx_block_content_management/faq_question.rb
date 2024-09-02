module BxBlockContentManagement
  class FaqQuestion < ApplicationRecord
    self.table_name = :faq_questions
    # Validations
    validates :question, :answer, presence: true
  end
end
module BxBlockContentManagement
  class Exam < ApplicationRecord
    self.table_name = :exams

    validates_presence_of :heading, :to, :from

    validate :check_to_and_from

    def name
      heading
    end

    private

    def check_to_and_from
      if self.to.present? && self.from.present? && self.to < self.from
        errors.add(:from, "can't be greater than to")
      end
    end
  end
end

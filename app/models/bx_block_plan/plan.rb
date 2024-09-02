# frozen_string_literal: true

module BxBlockPlan
  class Plan < BxBlockPlan::ApplicationRecord
    self.table_name = :plans
    enum duration: ['3 Months', '6 Months', '1 Year']

    validate :create_only_three, on: :create

    private

    def create_only_three
      errors.add(:base, "You can't create more than three plans.") if BxBlockPlan::Plan.count > 2
    end
  end
end

module BxBlockDashboardguests
  class DashboardGuest < BuilderBase::ApplicationRecord
    self.table_name = :bx_block_dashboardguests_dashboard_guests
    belongs_to :company, class_name: "BxBlockDashboardguests::Company"
    validates :invest_amount, presence: true
    validates :date_of_invest, presence: true
  end
end

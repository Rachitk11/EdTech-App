module BxBlockDashboardguests
  class Company < BxBlockDashboardguests::ApplicationRecord
    self.table_name = :bx_block_dashboardguests_companies
    has_one_attached :doc, dependent: :destroy
    validates :company_name, presence: true
  end
end

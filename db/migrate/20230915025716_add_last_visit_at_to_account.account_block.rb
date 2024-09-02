# This migration comes from account_block (originally 20210408132416)
class AddLastVisitAtToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :last_visit_at, :datetime
  end
end

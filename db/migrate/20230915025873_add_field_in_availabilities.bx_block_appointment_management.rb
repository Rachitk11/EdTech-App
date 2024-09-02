# This migration comes from bx_block_appointment_management (originally 20201130100305)
class AddFieldInAvailabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :availabilities, :available_slots_count, :integer
  end
end

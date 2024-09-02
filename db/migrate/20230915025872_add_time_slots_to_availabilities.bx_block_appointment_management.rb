# This migration comes from bx_block_appointment_management (originally 20201030085744)
class AddTimeSlotsToAvailabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :availabilities, :timeslots, :jsonb
  end
end

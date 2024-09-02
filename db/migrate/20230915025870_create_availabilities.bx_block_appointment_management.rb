# This migration comes from bx_block_appointment_management (originally 20200902105809)
class CreateAvailabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :availabilities do |t|
      t.references :service_provider
      t.string :start_time
      t.string :end_time
      t.string :unavailable_start_time
      t.string :unavailable_end_time
      t.string :availability_date
      t.timestamps
    end
  end
end

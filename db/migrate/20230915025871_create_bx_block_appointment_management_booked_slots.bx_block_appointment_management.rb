# This migration comes from bx_block_appointment_management (originally 20201014104937)
class CreateBxBlockAppointmentManagementBookedSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_appointment_management_booked_slots do |t|
      t.bigint :order_id
      t.string :start_time
      t.string :end_time
      t.bigint :service_provider_id
      t.date :booking_date
      t.timestamps
    end
  end
end

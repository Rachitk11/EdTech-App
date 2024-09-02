module BxBlockAppointmentManagement
  class BookedSlot < ApplicationRecord
    self.table_name = :bx_block_appointment_management_booked_slots

    belongs_to :service_provider, class_name: "AccountBlock::Account"
  end
end

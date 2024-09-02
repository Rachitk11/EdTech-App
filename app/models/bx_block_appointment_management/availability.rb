module BxBlockAppointmentManagement
  class Availability < ApplicationRecord
    include Wisper::Publisher
    self.table_name = :availabilities

    belongs_to :service_provider,
      class_name: "AccountBlock::Account", foreign_key: :service_provider_id
    scope :sp_details, ->(sp_id, availability_date) {
      find_by(service_provider_id: sp_id, availability_date: availability_date)
    }

    validates_presence_of :availability_date, :start_time, :end_time
    # validate :check_date
    validate :check_presence_of_days_slot, if: proc { |availability| availability.new_record? }

    before_save :set_params

    scope :todays_availabilities, -> {
      where(availability_date: Date.today.strftime("%d/%m/%Y")).first
    }
    scope :filter_by_date, ->(date) {
      where(availability_date: Date.parse(date).strftime("%d/%m/%Y"))
    }
    scope :available_service_provider, ->(date) {
                                         where(
                                           availability_date: Date.parse(date).strftime("%d/%m/%Y")
                                         ).order(:available_slots_count)&.first&.service_provider
                                       }
    after_create :create_time_slots, :update_slot_count

    def todays_online_hours
      # Date will be in hour
      full_day_slot = ((Time.parse(end_time) - Time.parse(start_time)) / 3600)
      if unavailable_end_time.present? && unavailable_start_time.present?
        unavailable_slot = ((Time.parse(unavailable_end_time) -
            Time.parse(unavailable_start_time)) / 3600)
      end
      unavailable_slot.present? ? full_day_slot - unavailable_slot : full_day_slot
    end

    def slots_list
      already_booked_slots = get_booked_slots(Date.strptime(availability_date, "%d/%m/%Y"))
      availability = self
      unless availability.present?
        return errors.add(
          :availability, "Service provider is unavailable for today"
        )
      end
      slots = BxBlockAppointmentManagement::TimeSlotsCalculator.new.calculate_time_slots(
        availability.start_time, availability.end_time, 59
      )
      slots.each_with_index do |slot, index|
        next if slot[:booked_status]
        already_booked_slots.each do |booked_slot|
          if (Time.parse(slot[:from])..Time.parse(slot[:to])).cover?(booked_slot[:start_time])
            slot[:booked_status] = true
            while slots[index + 1].present? && (booked_slot[:start_time]..booked_slot[:end_time]).cover?(Time.parse(slots[index + 1][:from]))
              slots[index + 1][:booked_status] = true
              index += 1
              break unless slots[index + 1].present?
            end
          end
        end
      end
      slots
    end

    def update_slot_count
      available_slots_count = slots_list.to_a.count { |time| time[:booked_status] == false }
      update(available_slots_count: available_slots_count)
    end

    private

    def check_date
      errors.add(:invalid_date, "Invalid Date, Please choose current date") unless
          Date.parse(availability_date).today?
    end

    def get_booked_slots order_date
      BookedSlot.where(
        service_provider_id: service_provider,
        booking_date: order_date
      ).map do |booked_slot|
        {start_time: booked_slot.start_time.to_time, end_time: booked_slot.end_time.to_time}
      end
    end

    def check_presence_of_days_slot
      if service_provider.present?
        slot = Availability.find_by(
          service_provider_id: service_provider.id,
          availability_date: Date.parse(availability_date).strftime("%d/%m/%Y")
        )
      end
      errors.add(:slot_error, "You have already slot for the day") if slot.present?
    end

    def set_params
      self.availability_date = Date.parse(availability_date).strftime("%d/%m/%Y")
      self.start_time = Time.parse(start_time).strftime("%I:%M %p")
      self.end_time = Time.parse(end_time).strftime("%I:%M %p")
      if unavailable_start_time.present?
        self.unavailable_start_time = Time.parse(unavailable_start_time).strftime("%I:%M %p")
      end
      if unavailable_end_time.present?
        self.unavailable_end_time = Time.parse(unavailable_end_time).strftime("%I:%M %p")
      end
    end

    def create_time_slots
      new_time_slots = TimeSlotsCalculator.new.calculate_time_slots(
        start_time, end_time, 59
      )
      update_column("timeslots", new_time_slots)
    end
  end
end
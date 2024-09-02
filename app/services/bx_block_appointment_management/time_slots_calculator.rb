module BxBlockAppointmentManagement
  class TimeSlotsCalculator
    def calculate_time_slots(start_time, end_time, slot_duration)
      total_working_hours = (Time.parse(end_time).strftime("%H").to_i -
                             Time.parse(start_time).strftime("%H").to_i)
      total_working_minutes = total_working_hours * 60
      new_time_slots = []
      new_start_time = start_time
      sno = 1
      until total_working_minutes < 1
        start_time_key = Time.parse(new_start_time).strftime("%I:%M %p").to_s
        end_time_key = (Time.parse(new_start_time) + slot_duration.minute).strftime("%I:%M %p").to_s
        new_time_slots << {
          from: start_time_key, to: end_time_key, booked_status: false, sno: sno.to_s
        }
        new_start_time = (Time.parse(new_start_time) +
                         (slot_duration + 1).minute).strftime("%I:%M %p")
        total_working_minutes -= slot_duration
        sno += 1
      end
      new_time_slots
    end
  end
end

module BxBlockAppointmentManagement
  # Create slot for 6 days in advance
  class CreateAvailabilityWorker
    include Sidekiq::Worker

    def perform availability_id
      availability_for_id(availability_id)
      if @availability.present?
        build_slots
        trriger_job
      end
    end

    def trriger_job
      BxBlockAppointmentManagement::AddOneDayAvailabilityWorker.perform_at(
        7.days.from_now, @availability.id
      )
    end

    def availability_for_id id
      @availability = BxBlockAppointmentManagement::Availability.find(id)
    end

    def build_slots
      date = Date.strptime(@availability.availability_date, "%d/%m/%Y") + 1.days
      6.times do
        value = @availability.dup
        value.availability_date = date.strftime("%d/%m/%Y")
        value.save
        date += 1.days
      end
    end
  end
end

module BxBlockAppointmentManagement
  class ServiceProviderAvailabilitySerializer < BuilderBase::BaseSerializer
    attributes :id, :availability_date

    attribute :time_slots do |object|
      slots_for(object)
    end

    class << self
      private

      def slots_for availability
        availability.slots_list
      end
    end
  end
end

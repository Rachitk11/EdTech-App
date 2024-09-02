module BxBlockLocation
  class VanLocationSerializer < BuilderBase::BaseSerializer
    attributes *[
      :latitude,
      :longitude,
    ]

    attribute :van do |object|
      object.van
    end

    attribute :service_provider do |object|
      AccountBlock::AccountSerializer.new(object.van.service_provider)
    end

    attribute :distance do |object, params|
      if params.present? && params[:coordinates].present?
        van_location = [object.latitude, object.longitude]
        find_distance_between_coordinates(params[:coordinates], van_location)
      else
        nil
      end
    end

    class << self
      def find_distance_between_coordinates start_address_coordinates, van_location
        Geocoder::Calculations.distance_between(start_address_coordinates, van_location, units: :km)
      end
    end
  end
end

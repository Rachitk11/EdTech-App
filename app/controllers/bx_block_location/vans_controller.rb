module BxBlockLocation
  class VansController < ApplicationController
    before_action :find_van, except: %i(near_vans estimated_arrival_time)
    before_action :lat_lon, only: %i(near_vans)

    COVERING_RADIOUS = 10
    DEFAULT_VEHICLE_SPEED = 30 #in km/hr

    def near_vans
      vans_location = BxBlockLocation::Location.near(lat_lon, COVERING_RADIOUS, unit: :km)
      vans_location.map(&:van)
      vans = BxBlockLocation::Van.where(is_offline: false).joins(:location).where(
        'locations.id = ?', vans_location.ids
      )
      vans_location = BxBlockLocation::Van.new.available_vans(vans)
      render json: {
        message: 'No van\'s present near your location'
      } and return unless vans_location.present?

      render json: BxBlockLocation::VanLocationSerializer.new(
        vans_location,
        params: {coordinates: lat_lon},
        meta: {message: 'List of all near vans'}
      ), status: :ok
    end

    def estimated_arrival_time
      service_provider = AccountBlock::Account.find(params[:service_provider_id])
      render json: {
        errors: 'Please select service provider'
      } and return unless service_provider.present?

      van_member = BxBlockLocation::VanMember.find_by_account_id(service_provider.id)
      van = BxBlockLocation::Van.find_by_id(van_member.van_id)

      address = BxBlockAddress::Address.find(params[:address_id])
      render json: estimated_time_arrival_for(address, van.location)
    end

    def show
      render json: BxBlockLocation::VanLocationSerializer.new(
        @van.location,
        meta: { message: 'Location of van' }
      ), status: :ok
    end

    def update
      
      render json: BxBlockLocation::VanLocationSerializer.new(
        @van.location,
        meta: { message: 'Location updated successfully' }
      ), status: :ok and return if @van.location.update(van_params)

      render json: { errors: 'Something goes wrong, location is not updated' }
    end

    private

    def find_van
      @van = BxBlockLocation::Van.find(params[:id])
    end

    def van_params
      params.permit(:latitude, :longitude)
    end

    def lat_lon
      render json: {
        errors: 'Please send location'
      } and return unless params[:latitude].present? and params[:longitude].present?
      [params[:latitude], params[:longitude]]
    end

    def estimated_time_arrival_for address, van_location
      distance = Geocoder::Calculations.distance_between(
        address.to_coordinates, van_location.to_coordinates, units: :km
      )
      return {errors: 'Something went wrong'} unless distance.present?
      estimated_time = distance / DEFAULT_VEHICLE_SPEED
      { estimated_time: estimated_time }
    end
  end
end

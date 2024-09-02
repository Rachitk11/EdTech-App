module BxBlockAddress
  class AddressesController < BxBlockAddress::ApplicationController
    before_action :get_account, only: [:index, :create, :update, :destroy]
    before_action :find_address, only: [:update, :destroy]
    before_action :validate_address_type, only: [:create, :update]

    def index
      @account_addresses = Address.where(addressble_id: @account.id)
      unless @account_addresses.present?
        render json: {
          message: "No Address is present"
        } and return
      end
      render json: BxBlockAddress::AddressSerializer.new(
        @account_addresses, meta: {message: "List of all addresses"}
      ).serializable_hash
    end

    def create
      @address = Address.new(full_params)
      if @address.save
        render json: BxBlockAddress::AddressSerializer.new(@address, meta: {
          message: "Address Created Successfully"
        }).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@address.errors)},
          status: :unprocessable_entity
      end
    end

    def update
      if @address.update(full_params)
        render json: BxBlockAddress::AddressSerializer.new(@address, meta: {
          message: "Address Updated Successfully"
        }).serializable_hash, status: :ok
      else
        render json: {errors: format_activerecord_errors(@address.errors)},
          status: :unprocessable_entity
      end
    end

    def destroy
      if @address.destroy
        render json: {message: "Address deleted succesfully!"}, status: :ok
      else
        render json: {errors: format_activerecord_errors(@address.errors)},
          status: :unprocessable_entity
      end
    end

    private

    def address_params
      params.require(:address).permit(:latitude, :longitude, :address, :address_type)
    end

    def full_params
      @full_params ||= address_params.merge({addressble_id: @account.id,
                                               addressble_type: "AccountBlock::Account"})
    end

    def find_address
      @address = Address.find_by(addressble_id: @account.id, id: params[:id])
      return render json: {message: "Address does not exist."}, status: :not_found if @address.nil?
    end

    def validate_address_type
      if full_params[:address_type].present? && !BxBlockAddress::Address.address_types.key?(full_params[:address_type])
        render json: {message: "Address type is not valid."}, status: :unprocessable_entity and return
      end
    end
  end
end

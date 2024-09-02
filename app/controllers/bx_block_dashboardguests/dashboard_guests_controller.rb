module BxBlockDashboardguests
  class DashboardGuestsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:show, :index, :portfolio]
    before_action :load_guest, only: [:show, :update, :destroy]
  
    def index
      guests = DashboardGuest.all
      render json: DashboardGuestSerializer.new(guests, params: { host: request.protocol + request.host_with_port }), status: :ok
    end

    def portfolio
      account = AccountBlock::Account.find_by(uniq_id: params[:uniq_id].to_s)
      render json: DashboardGuestSerializer.new(account.bx_block_dashboardguests_dashboard_guests, params: { host: request.protocol + request.host_with_port }), status: :ok
    end

    def create
      @guest = DashboardGuest.new(guest_params.merge(account_id: @token.id))
      if @guest.save
        render json: DashboardGuestSerializer.new(@guest, params: { host: request.protocol + request.host_with_port }).serializable_hash, status: :created
      else
        render json: {'errors' => [@guest.errors.full_messages.to_sentence]}, status: :unprocessable_entity
      end
    end

    def show
      render json: DashboardGuestSerializer.new(@guest, params: { host: request.protocol + request.host_with_port }).serializable_hash, status: :ok
    end

    def destroy
      @guest.destroy
      render json: { success: true }, status: :ok
    end

    def update
      if @guest.update(guest_params)
        render json: DashboardGuestSerializer.new(@guest, params: { host: request.protocol + request.host_with_port }), status: :ok
      else
        render json: {'errors' => [@guest.errors.full_messages.to_sentence]}, status: :unprocessable_entity
      end
    end

    private

    def load_guest
      @guest = DashboardGuest.find_by(id: params[:id])
      if @guest.nil?
        return render json: {
            message: "Guest with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def guest_params
      params.require(:data).permit(:company_id, :invest_amount, :date_of_invest)
    end
  end
end

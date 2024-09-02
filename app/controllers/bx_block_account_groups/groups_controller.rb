module BxBlockAccountGroups
  class GroupsController < ApplicationController
    before_action :check_account_role
    before_action :check_is_admin, only: [:create, :update, :add_accounts, :remove_accounts, :destroy]
    before_action :find_group, only: [:show, :update, :add_accounts, :remove_accounts, :destroy]

    def index
      render json: GroupSerializer.new(my_groups), status: :ok
    end

    def show
      if @group.blank?
        render json: {errors: [{group: "Not found"}]}, status: :not_found
      else
        render json: GroupSerializer.new(@group).serializable_hash, status: :ok
      end
    end

    def create
      group = Group.new(group_create_params)
      unless group.save
        render json: {errors: group.errors}, status: :unprocessable_entity
      end

      if params[:group]["account_ids"].present?
        accounts = AccountBlock::Account.where(id: params[:group]["account_ids"])
        group.accounts = accounts if accounts&.present?
      end

      if group.save
        render json: GroupSerializer.new(group).serializable_hash, status: :created
      end
    end

    def update
      if @group.update(group_update_params)
        render json: GroupSerializer.new(@group).serializable_hash, status: :ok
      else
        render json: {errors: @group.errors}, status: :unprocessable_entity
      end
    end

    def add_accounts
      if params[:account_ids].blank?
        render json: {
          errors: [{message: "No account ids provided"}]
        }, status: :unprocessable_entity and return
      end

      accounts_to_add = AccountBlock::Account.where(id: params[:account_ids]).where.not(id: @group.accounts.map(&:id))
      @group.accounts << accounts_to_add
      render json: GroupSerializer.new(@group).serializable_hash, status: :ok
    end

    def remove_accounts
      if params[:account_ids].blank?
        render json: {
          errors: [{message: "No account ids provided"}]
        }, status: :unprocessable_entity and return
      end

      accounts_to_remove = AccountBlock::Account.where(id: params[:account_ids])
      @group.accounts = @group.accounts.excluding(accounts_to_remove)
      render json: GroupSerializer.new(@group).serializable_hash, status: :ok
    end

    def destroy
      if @group.destroy
        render json: {message: "Group deleted successfully!"}, status: :ok
      else
        render json: GroupSerializer.new(@group).serializable_hash, status: :unprocessable_entity
      end
    end

    private

    def group_create_params
      params.require(:group).permit(:name, :settings, settings: {})
    end

    def group_update_params
      params.require(:group).permit(:name, :settings, settings: {}, account_ids: [])
    end

    def check_account_role
      unless current_user.role.present? && [Group::ROLE_ADMIN, Group::ROLE_BASIC].include?(current_user.role.name)
        render json: {
          errors: [{message: "Account does not have a proper role"}]
        }, status: :unprocessable_entity
      end
    end

    def check_is_admin
      unless current_user.is_groups_admin?
        render json: {
          errors: [{message: "Only account group admin has permission for this"}]
        }, status: :unprocessable_entity
      end
    end

    def find_group
      unless current_user.is_groups_admin?
        if current_user.groups.empty? || !current_user.groups.any? { |group| group.id == params[:id].to_i }
          return render json: {
            errors: [{message: "You don't have access to this account group"}]
          }, status: :unprocessable_entity
        end
      end

      @group ||= Group.find_by_id(params[:id])

      unless @group.present?
        render json: {
          errors: [{message: "Group not found"}]
        }, status: :not_found
      end
    end

    def my_groups
      current_user.is_groups_admin? ? Group.all : current_user.groups
    end
  end
end

module BxBlockAnalytics7
  class PublisherAnalyticsController < ApplicationController
    before_action :validate_json_web_token, :current_user

    def publisher_analytics
      if current_user.present?
        if current_user.role.name == "Publisher"
          @all_teachers = count_users_by_role("Teacher")
          @all_school_admin = count_users_by_role("School Admin")
          @all_students = count_users_by_role("Student")
          @all_publishers = count_users_by_role("Publisher")
          @all_ebooks = BxBlockBulkUploading::Ebook.all.count
          @all_users = @all_teachers + @all_school_admin + @all_students
          @last_week_change = calculate_last_week_change
          @total_ebooks_sold = 0
          @last_week_ebooks = 0
          @total_revenue = 0
          @last_week_revenue = 0
          users_data = { total_users: @all_users, last_week: @last_week_change }
          ebooks_data = { total_ebooks_sold: @total_ebooks_sold, last_week_ebooks: @last_week_ebooks }
          revenue_generated = { total_revenue: @total_revenue, last_week_revenue: @last_week_revenue }
          render json: { users_data: users_data, ebooks_data: ebooks_data, revenue_generated: revenue_generated, success: true }, status: :ok
        else
          render json: { message: "Invalid User!" }, status: :unprocessable_entity
        end
      else
        render json: { message: "User Not Found!" }, status: :not_found
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def count_users_by_role(role_name)
      AccountBlock::Account.joins(:role).where(roles: { name: role_name }).size
    end

    def calculate_last_week_change
      last_week_teachers = count_users_by_role_created_last_week("Teacher")
      last_week_school_admin = count_users_by_role_created_last_week("School Admin")
      last_week_students = count_users_by_role_created_last_week("Student")
      # last_week_publishers = count_users_by_role_created_last_week("Publisher")

      last_week_teachers + last_week_school_admin + last_week_students
    end

    def count_users_by_role_created_last_week(role_name)
      AccountBlock::Account.joins(:role)
                         .where(roles: { name: role_name })
                         .where(created_at: 1.week.ago..Time.now)
                         .size
    end
  end
end

module BxBlockContactUs
  class ContactsController < ApplicationController
    FORGOT_PASSWORD = "Forgot Password"
    STUDENT = "Student"
    TEACHER = "Teacher"
    SCHOOL_ADMIN = "School Admin"
    PUBLISHER = "Publisher"

    def create
      if ![PUBLISHER, TEACHER, SCHOOL_ADMIN, STUDENT].include?(params[:data][:type])
        return render json: {errors: [
          {account: "Invalid User Type"}
        ]}, status: :unprocessable_entity
      end

      if !params[:data][:email].present?
        return render json: {errors: "please provide email id"}
      end

      message = (params[:data][:type] == 'School Admin') ? true : forgot_password

      if message != true
        return render json: {errors: message}
      end
    
      if params[:data][:issue] != FORGOT_PASSWORD && !params[:data][:name]
        return render json: {errors: "please provide #{params[:data][:type]} name"}
      end

      if [PUBLISHER, TEACHER, SCHOOL_ADMIN].include?(params[:data][:type]) && params[:data][:issue] == FORGOT_PASSWORD
        @account = AccountBlock::Account.where("lower (email) = ?", params[:data][:email].downcase).last
      elsif params[:data][:type] == STUDENT && params[:data][:issue] == FORGOT_PASSWORD
        @account = AccountBlock::Account.where(student_unique_id: params[:data][:unique_id]).last   
      end
      @contact = Contact.create(contact_params)
       check_issue(@account)
    end

    def forgot_password
      if (params[:data][:type] == STUDENT || params[:data][:type] == TEACHER) && params[:data][:issue] == FORGOT_PASSWORD && !params[:data][:unique_id].present?
        return "please provide #{params[:data][:type]} id"
      end

      if params[:data][:type] == SCHOOL_ADMIN && params[:data][:issue] == FORGOT_PASSWORD && !params[:data][:school_id].present?
        return 'please provide school name'
      end
       return true
    end

    def forgot_password_issues
      return 'Invalid email address' if invalid_email_address?
      return 'Invalid unique id' if invalid_unique_id?
      return 'please provide valid teacher id' if invalid_teacher_id?
      return 'please provide valid guardian email' if invalid_guardian_email?
      true
    end

    def invalid_email_address?
      !@account.present? && params.dig(:data, :issue) == FORGOT_PASSWORD && params.dig(:data, :type) != STUDENT
    end

    def invalid_unique_id?
      !@account.present? && params.dig(:data, :issue) == FORGOT_PASSWORD
    end

    def invalid_teacher_id?
      @account.present? && params.dig(:data, :type) == TEACHER && @account.teacher_unique_id != params.dig(:data, :unique_id)
    end

    def invalid_guardian_email?
      @account.present? && params.dig(:data, :type) == STUDENT && @account.guardian_email.downcase != params.dig(:data, :email).downcase
    end

    private

    def check_issue(account)
      if params[:data][:issue] != FORGOT_PASSWORD
        render json: {message: 'your request has submitted successfully'}, status: :created
      elsif account&.activated? && params[:data][:issue] == FORGOT_PASSWORD
        issue = forgot_password_issues
        if issue != true
          return render json: {errors: issue}
        end
        create_email_otp(contact_params)
        render json: {message: 'Please check your email for one time pin'}, status: :created
      else
        render json: {message: 'Please first activate your account'}
      end
    end

    def send_email_for(otp_record)
      BxBlockForgotPassword::EmailOtpMailer.with(otp: otp_record, host: request.base_url, incoming_params: params).otp_email.deliver
    end

    def create_email_otp(email)
      email_otp = AccountBlock::EmailOtp.new(email: contact_params[:email])
      
      if email_otp.save
        @account.update(is_reset: true, one_time_pin: email_otp.pin , pin: email_otp.pin)
        send_email_for(email_otp)
      else
        render json: { errors: [email_otp.errors] }, status: :unprocessable_entity
      end
    end

    def contact_params
      params.require(:data).permit(:name, :email, :phone_number, :description, :issue)
    end
  end
end

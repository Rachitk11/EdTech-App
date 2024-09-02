module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:deactivate,:search, :change_email_address, :change_phone_number, :specific_account, :logged_user]

    SCHOOL_NAME_INVALID = "School name is invalid"
    CONTACT_NUMBER_INVALID = "Contact Number is invalid"
    ALREADY_REGISTRED = "Already registred"

    def create
      # case params[:data][:type] #### rescue invalid API format
      # when "Student"
      #   validate_json_web_token

      #   unless valid_token?
      #     return render json: {errors: [
      #       {token: "Invalid Token"}
      #     ]}, status: :bad_request
      #   end

      #   begin
      #     # @sms_otp = SmsOtp.find(@token[:id])
      #     @school = BxBlockCategories.where(name: params[:data][:school_name]).last
      #     @student = AccountBlock::Account.where(guardian_email: params[:guardian_email], student_unique_id: params[:data][:student_id], school_id: @school.id)
      #   rescue ActiveRecord::RecordNotFound => e
      #     return render json: {errors: [
      #       {phone: "Please provide valid details"}
      #     ]}, status: :unprocessable_entity
      #   end

      # when "Teacher"
      #   # account_params = jsonapi_deserialize(params)
      #   @school = BxBlockCategories.where(name: params[:data][:school_name]).last
      #   @teacher = AccountBlock::Account.where(teacher_unique_id: params[:data][:teacher_id], full_phone_number: params[:data][:contact_number], school_id: @school.id).first

      # when "School Admin"
      #   @account = SocialAccount.new(jsonapi_deserialize(params))
      #   @account.password = @account.email
      #   if @account.save
      #     render json: SocialAccountSerializer.new(@account, meta: {
      #       token: encode(@account.id)
      #     }).serializable_hash, status: :created
      #   else
      #     render json: {errors: format_activerecord_errors(@account.errors)},
      #       status: :unprocessable_entity
      #   end

      # else
      #   render json: {errors: [
      #     {account: "Invalid Account Type"}
      #   ]}, status: :unprocessable_entity
      # end
      account = AccountBlock::Account.find(params[:id])
      if update_params[:pin] != params[:data][:confirm_pin]
        return render json: {message: "confirm pin is wrong"}
      end
      if account.activated == true
        return render json: {errors: ALREADY_REGISTRED}
      end
      updated_account = account.update(pin: update_params[:pin], activated: true) if update_params[:pin].present?

      if updated_account
        token, refresh = generate_tokens(account.id)
        return render json: AccountBlock::AccountSerializer.new( account, meta: {
            token: token, refresh_token: refresh}).as_json.merge({step: 4})
      else
        render json: account.errors, status: :unprocessable_entity
      end
   end

    def update
      account = AccountBlock::Account.find_by(id: params[:id])
      account.update(update_params)
      return render json: AccountBlock::AccountSerializer.new(account).as_json.merge({step: 2})
    end

    def show
      account = AccountBlock::Account.find_by(id: params[:id])
      return render json: AccountBlock::AccountSerializer.new(account).as_json.merge({step: 1})
    end

    def user_data
      case params[:type]
      when "Student"
        for_student
      when "Teacher"
        for_teacher
      when "School Admin"
       for_school_admin
      when "Publisher"
        for_publisher
      else
        render json: {errors: [
          {account: "Invalid User Type"}
        ]}, status: :unprocessable_entity
      end
    end

    def for_student
      @student = AccountBlock::Account.where(student_unique_id: params[:data][:unique_id]).last
      if @student.present?
        (@student.activated && @student.pin.present?) ? (render json: { errors: ALREADY_REGISTRED }) : student_errors
      else
        render json: { errors: "Please provide valid student id" }
      end
    end
    def for_teacher
      @teacher = AccountBlock::Account.where(teacher_unique_id: params[:data][:unique_id], school_id: params[:data][:school_id]).last
      if @teacher.nil?
        render json: { errors: "Please provide valid unique_id" }
      elsif @teacher.activated && @teacher.pin.present?
        render json: { errors: ALREADY_REGISTRED }
      elsif params[:data][:contact_number] != @teacher.full_phone_number
        render json: { errors: CONTACT_NUMBER_INVALID }
      else
        render json: AccountBlock::AccountSerializer.new(@teacher).as_json.merge({ step: 1 })
      end
    end
    def for_school_admin
      @school_admin = AccountBlock::Account.where(email: params[:data][:email].downcase).last
      if @school_admin.present?
        condition = @school_admin.activated && @school_admin.pin.present?
        condition ? render(json: { errors: "ALREADY_REGISTERED" }) : school_admin_errors
      else 
        return render json: {errors: "Please provide valid email"}
      end
    end

    def for_publisher
      @publisher = AccountBlock::Account.where(email: params[:data][:email].downcase).last
      if @publisher.present?
        condition = @publisher.activated && @publisher.pin.present?
        condition ? render(json: { errors: ALREADY_REGISTRED }) :  publisher_errors
      else 
        return render json: {errors: "Account is not exist"}
      end
    end

    def student_errors
      if params[:data][:school_id].to_i != @student.school_id
        return render json: {errors: SCHOOL_NAME_INVALID}
      end
      if params[:data][:email].present? && @student.guardian_email&.downcase != params[:data][:email].downcase
        return render json: {errors: "Guardian Email is invalid"}
      end
      return render json: AccountBlock::AccountSerializer.new(@student).as_json.merge({step: 1})
    end

    def publisher_errors
      if params[:data][:publication_name].downcase != @publisher.publication_house_name.downcase
        return render json: {errors: "Publication name is invalid"}
      end
      if params[:data][:contact_number] != @publisher.full_phone_number
        return render json: {errors: CONTACT_NUMBER_INVALID}
      end
      return render json: AccountBlock::AccountSerializer.new(@publisher).as_json.merge({step: 1})
    end
       

    def school_admin_errors
      if params[:data][:school_id].to_i != @school_admin.school_id
        return render json: {errors: SCHOOL_NAME_INVALID}
      end
      if params[:data][:contact_number] != @school_admin.full_phone_number
        return render json: {errors: CONTACT_NUMBER_INVALID}
      end
      return render json: AccountBlock::AccountSerializer.new(@school_admin).as_json.merge({step: 1})
    end

    def validate_unique_id
      case params[:data][:type]
      when "Student"
        @st = AccountBlock::Account.where(student_unique_id: params[:data][:unique_id]).last
      when "Publisher"
        @st = AccountBlock::Account.where(email: params[:data][:email].downcase).last
      when "School Admin"
        @st = AccountBlock::Account.where(email: params[:data][:email].downcase).last
      when "Teacher"
        @st = AccountBlock::Account.where(teacher_unique_id: params[:data][:unique_id], school_id: params[:data][:school_id]).last
      else
        return render json: {errors: [
          {account: "Please Provide valid details"}
        ]}, status: :unprocessable_entity
      end
        
      if @st.present?
        return render json: AccountBlock::AccountSerializer.new(@st), status: :ok
      else
        return render json: {errors: "Please provide valid details"}
      end
    end

    # def search
    #   @accounts = Account.where(activated: true)
    #     .where("first_name ILIKE :search OR " \
    #                        "last_name ILIKE :search OR " \
    #                        "email ILIKE :search", search: "%#{search_params[:query]}%")
    #   if @accounts.present?
    #     render json: AccountSerializer.new(@accounts, meta: {message: "List of users."}).serializable_hash, status: :ok
    #   else
    #     render json: {errors: [{message: "Not found any user."}]}, status: :ok
    #   end
    # end

    # def change_email_address
    #   query_email = params["email"]
    #   account = EmailAccount.where("LOWER(email) = ?", query_email).first

    #   validator = EmailValidation.new(query_email)

    #   if account || !validator.valid?
    #     return render json: {errors: "Email invalid"}, status: :unprocessable_entity
    #   end
    #   @account = Account.find(@token.id)
    #   if @account.update(email: query_email)
    #     render json: AccountSerializer.new(@account).serializable_hash, status: :ok
    #   else
    #     render json: {errors: "account user email id is not updated"}, status: :ok
    #   end
    # end

    # def change_phone_number
    #   @account = Account.find(@token.id)
    #   if @account.update(full_phone_number: params["full_phone_number"])
    #     render json: AccountSerializer.new(@account).serializable_hash, status: :ok
    #   else
    #     render json: {errors: "account user phone_number is not updated"}, status: :ok
    #   end
    # end

    # def specific_account
    #   @account = Account.find(@token.id)
    #   if @account.present?
    #     render json: AccountSerializer.new(@account).serializable_hash, status: :ok
    #   else
    #     render json: {errors: "account does not exist"}, status: :ok
    #   end
    # end

    # def index
    #   @accounts = Account.all
    #   if @accounts.present?
    #     render json: AccountSerializer.new(@accounts).serializable_hash, status: :ok
    #   else
    #     render json: {errors: "accounts data does not exist"}, status: :ok
    #   end
    # end

    # def logged_user
    #   @account = Account.find(@token.id)
    #   if @account.present?
    #     render json: AccountSerializer.new(@account).serializable_hash, status: :ok
    #   else
    #     render json: {errors: "account does not exist"}, status: :ok
    #   end
    # end

    def deactivate
      account = AccountBlock::Account.find(@token.id)
      if account.activated 
        account.update(activated: false)
        render json: { message: "Your account has been deactivated." }      
      else
        render json: { errors: ["Your account is already deactivated."] }, status: :unprocessable_entity
      end
    end


    # private

    def generate_tokens(account_id)
      [
        BuilderJsonWebToken.encode(account_id, 1.day.from_now, token_type: 'sign_up'),
        BuilderJsonWebToken.encode(account_id, 1.year.from_now, token_type: 'refresh')
      ]
    end

    # def search_params
    #   params.permit(:query)
    # end

    def update_params
      params.require(:data).permit(:ifsc_code, :bank_account_number, :publication_house_name, :guardian_name, :first_name, :guardian_contact_no, :pin, :role_id, :full_phone_number)
    end
  end
end

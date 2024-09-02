
include Warden::Test::Helpers
RSpec.describe Admin::AllOrdersController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before(:each) do
    @admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
    @admin.role = "super_admin"
    @admin.password = "password"
    @admin.save
    sign_in @admin
    @student_role = FactoryBot.create(:role, name: "Student")
    @teacher_role = FactoryBot.create(:role, name: "Teacher")
    @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, teacher_unique_id: "TECH00099")
    @school = FactoryBot.create(:school, name: "Standard Fort", phone_number: 9854309309)
    @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id, division_name: "A")
    @school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division], class_number: 1)

    @student_account = FactoryBot.create(:account, role_id: @student_role.id , student_unique_id: "ST9609", class_division_id: @class_division.id, school_class_id: @school_class.id, school_id: @school.id)
    @student_token = BuilderJsonWebToken.encode(@student_account.id)
    @my_order = FactoryBot.create(:order, account_id: @student_account.id, status: "created" )

  end

  describe 'GET #index' do
    it 'displays the list of orders' do
      create(:order, account_id: @student_account.id, status: "created")
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let(:order) { create(:order, account_id: @student_account.id, status: "created") }

    it "returns a successful response" do
      get :show, params: { id: order.id }
      expect(response).to be_successful
    end
  end
end
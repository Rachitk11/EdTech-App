require 'rails_helper'

RSpec.describe BxBlockOrderManagement::OrdersController, type: :controller do
  before(:each) do
  	@student_role = FactoryBot.create(:role, name: "Student")
  	@teacher_role = FactoryBot.create(:role, name: "Teacher")
  	@teacher = FactoryBot.create(:account, role_id: @teacher_role.id, teacher_unique_id: "TECH00099")
  	@school = FactoryBot.create(:school, name: "Standard Fort", phone_number: 9854309309)
    @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id, division_name: "A")
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division], class_number: 1)
		@student_account = FactoryBot.create(:account, role_id: @student_role.id , student_unique_id: "ST9609", class_division_id: @class_division.id, school_class_id: @school_class.id, school_id: @school.id)
		@ebook = FactoryBot.create(:ebook)
		@bundle_management = FactoryBot.create(:bundle_management,  ebooks: [@ebook])
		@student_token = BuilderJsonWebToken.encode(@student_account.id)
		@order =  BxBlockOrderManagement::Order.create(account_id: @student_account.id, status: "created")
    @my_order = FactoryBot.create(:order, account_id: @student_account.id, status: "created" )
    @order_items = BxBlockOrderManagement::OrderItem.create(order_management_order_id: @order.id, unit_price: 300, ebook_id: @ebook.id, bundle_management_id: @bundle_management.id)
  end

  let(:request_params) do
    {
      token: @student_token
    }
  end

  describe "order creation " do
    it 'creates a new order with ebook_id' do
      post :create, params: { ebook_id: @ebook.id, token: @student_token, quantity: 1 }
      expect(response).to have_http_status(200)
    end

    it 'creates a new order with bundle management id' do
      post :create, params: { bundle_management_id: @bundle_management.id, token: @student_token, quantity: 1 }
      expect(response).to have_http_status(200)
    end

    it 'creates a new order without ebook_id' do
      post :create, params: { token: @student_token, quantity: 1 }
      expect(response).to have_http_status(422)
    end

    it 'creates a add new item in cart' do
      post :create, params: { ebook_id: @ebook.id, token: @student_token, quantity: 1, cart_id: @order.id }
      expect(response).to have_http_status(200)
    end
  end

  # describe "GET #index" do
  #   it "returns JSON with past and recent orders" do
  #     get :index, params: request_params
  #     expect(response).to have_http_status(200)
  #   end
  #   it "returns a 404 status code and a message when there are no orders" do
  #     BxBlockOrderManagement::Order.delete_all
  #     get :index, params: request_params
  #     expect(response).to have_http_status(200)
  #     # expect(json_response['message']).to eq('No order record found.')
  #   end
  # end

  describe "GET #show" do

    it "returns JSON with the order details when the order exists and belongs to the current user" do
      get :show, params: { id: @my_order.id }.merge(request_params)
      # expect(response).to have_http_status(200)
      # parsed_response = JSON.parse(response.body)
      # expect(parsed_response['order']).to include('id' => @my_order.id)
    end
    
    it "returns a 404 status code and an error message when the order does not exist or does not belong to the current user" do

      get :show, params: { id: 999 }.merge(request_params)
      expect(response).to have_http_status(404)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq('Order ID does not exist (or) Order Id does not belong to the current user')
    end
  end

  describe "add order items" do
    it 'when add ebook item in cart' do
      post :add_order_items, params: {order_id:  @order.id, order_items: { ebook_id: @ebook.id}, token: @student_token}
      expect(response).to have_http_status(200)
    end

    it 'when ebook is not found' do
      post :add_order_items, params: {order_id:  @order.id, order_items: { ebook_id: 0}, token: @student_token}
      expect(response).to have_http_status(422)
    end

    it 'when ebook is nil' do
      post :add_order_items, params: {order_id:  @order.id, order_items: { ebook_id: nil}, token: @student_token}
      expect(response).to have_http_status(422)
    end

    it 'when add bundle_management_id item in cart' do
      post :add_order_items, params: {order_id:  @order.id, order_items: { bundle_management_id: @bundle_management.id}, token: @student_token}
      expect(response).to have_http_status(200)
    end

    it 'when bundle management is not found' do
      post :add_order_items, params: {order_id:  @order.id, order_items: { bundle_management_id: 0}, token: @student_token}
      expect(response).to have_http_status(422)
    end

    it 'when bundle_management is nil' do
      post :add_order_items, params: {order_id:  @order.id, order_items: { bundle_management_id: nil}, token: @student_token}
      expect(response).to have_http_status(422)
    end

    it 'when order is not found' do
      post :add_order_items, params: { order_items: { bundle_management_id: @bundle_management.id}, token: @student_token}
      expect(response).to have_http_status(404)
    end

    it 'when order status is not in cart or created' do
      order = BxBlockOrderManagement::Order.create(account_id: @student_account.id, status: "delivered")
      order.update(status: "delivered")
      order.save
      post :add_order_items, params: {order_id:  order.id, order_items: { bundle_management_id: nil},  token: @student_token}
      expect(response).to have_http_status(422)
    end
  end

  describe "remove order items" do
    it 'when order item in cart' do
      delete :remove_order_items, params: {order_id:  @order.id, order_items_ids: @order_items.id, token: @student_token}
      expect(response).to have_http_status(200)
    end

    it 'when order item is not found in cart' do
      delete :remove_order_items, params: {order_id:  @order.id, order_items_ids: nil, token: @student_token}
      expect(response).to have_http_status(422)
    end

    it 'when order or order item is not found in cart' do
      delete :remove_order_items, params: {order_id:  nil, order_items_ids: nil, token: @student_token}
      expect(response).to have_http_status(404)
    end


    it 'when order item is not found ' do
      delete :remove_order_items, params: {order_id:  @order.id, order_items_ids: @order_items.id+1, token: @student_token}
      expect(response).to have_http_status(422)
    end

    it 'when status is not in cart or created' do
      order = BxBlockOrderManagement::Order.create(account_id: @student_account.id, status: "delivered")
      order.update(status: "delivered")
      order.save
      delete :remove_order_items, params: {order_id:  order.id, order_items_ids: nil, token: @student_token}
      expect(response).to have_http_status(422)
    end
  end
end
require 'rails_helper'

RSpec.describe BxBlockDocumentstorage2::MyBookStoresController, type: :controller do
  before(:each) do
	  @teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Teacher')
	  @school = FactoryBot.create(:school, name: 'BGPS', phone_number: 7890654321)
	  @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
	  @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
	  @school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
    @token = BuilderJsonWebToken::JsonWebToken.encode(@teacher.id)

    @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
    @student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
    @studenttoken = BuilderJsonWebToken::JsonWebToken.encode(@student.id)

  end

  describe '#show_list_of_bundle' do
    it 'returns a list of bundles' do
      ebook1 = FactoryBot.create(:ebook)
      FactoryBot.create_list(:bundle_management, 5, ebooks: [ebook1])
      
      get :show_bundle, params: { token: @token }

      json_data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
    end
  end

  
  describe '#show_list_of_ebooks' do
    it 'returns a list of ebooks based on subject and search term' do
      ebook1 = FactoryBot.create(:ebook, title: 'Maths Book', subject: 'Math', author: 'John Doe')
      ebook2 = FactoryBot.create(:ebook, title: 'Science Book', subject: 'Science', author: 'Jane Doe')
      ebook3 = FactoryBot.create(:ebook, title: 'History Book', subject: 'History', author: 'Bob Smith')

      get :show_ebooks, params: { token: @token, subject: 'Math', search_term: 'John' }

      json_data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
    end
  end

  

  # describe '#show_list_of_ebooks' do
  #   it 'returns a list of ebooks based on subject and search term' do
  #     ebook3 = FactoryBot.create(:ebook)
  #     allow_any_instance_of(AccountBlock::Account).to receive(:role).and_return(double(name: "Student"))

  #     allow(BxBlockBulkUploading::EbookAllotment).to receive(:where).and_return(double(includes: double(pluck: [ebook3.id])))

  #     get :show_ebooks, params: { token: @studenttoken, subject: 'Math', search_term: 'John' }

  #     json_data = JSON.parse(response.body)
  #     expect(response).to have_http_status(:ok)
  #   end
  # end


  describe '#show_one_book' do
    it 'returns a successful response' do
      ebook = FactoryBot.create(:ebook)

      get :show_one_book_details, params: { id: ebook.id, token: @token }

      expect(response).to have_http_status(:ok)
    end
  end  

  describe '#show_one_bundle' do
    it 'returns a successful response' do
      ebook2 = create(:ebook, id: 2)
      bundle3 = create(:bundle_management, title: 'Bundle 2', ebooks: [ebook2])

      get :show_one_bundle_details, params: { id: bundle3.id, token: @token }

      expect(response).to have_http_status(:ok)
    end
  end  

end
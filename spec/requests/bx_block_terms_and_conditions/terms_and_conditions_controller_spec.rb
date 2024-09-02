require 'rails_helper'

RSpec.describe BxBlockTermsAndConditions::TermsAndConditionsController, type: :controller do
  before(:each) do
    BxBlockTermsAndConditions::TermsAndCondition.delete_all
    @term = BxBlockTermsAndConditions::TermsAndCondition.create(name: "name2", description: "This is description2")
    @role = FactoryBot.create(:role)
    @current_user = FactoryBot.create(:account, id: 30467, full_phone_number: '2514563987', role: @role, student_unique_id: 5648, teacher_unique_id: 5556)
    @user_term = BxBlockTermsAndConditions::UserTermAndCondition.create(terms_and_condition_id: @term.id, account_id: @current_user.id, is_accepted: false)
    @user_token = BuilderJsonWebToken.encode(@current_user.id)
  end

  describe 'GET #show' do
    
    context 'when a terms and condition record exists' do
      it 'returns the terms and conditions in JSON format with status code 200' do
        get :show
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'application/json; charset=utf-8'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['type']).to eq 'terms_and_conditions'
        expect(parsed_response['data']['attributes']['id']).to eq @term.id
      end
    end

    context 'when no terms and condition record exists' do
      it 'returns a not found message with status code 404' do
        BxBlockTermsAndConditions::TermsAndCondition.delete_all
        get :show
        expect(response).to have_http_status(:not_found)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq 'terms and conditions data not found'
      end
    end
  end

  describe 'POST #latest_record' do
    context 'when terms and conditions exist' do
      
      # it 'updates user term and condition when terms are accepted and user term exists' do
      #   update_params = { is_accepted: true }

      #   post :latest_record, params: { id: @current_user.id, data: update_params }
      #   expect(response).to have_http_status(:ok)
      #   parsed_response = JSON.parse(response.body)
      #   expect(parsed_response['message']).to eq('Terms and Conditions retrieved successfully!')
      # end

      # it 'creates user term and condition when terms are accepted and user term does not exist' do
      #   update_params = { is_accepted: true }
      #   user_term = BxBlockTermsAndConditions::UserTermAndCondition.create(account_id: @current_user.id, terms_and_condition_id: @term.id, is_accepted: update_params)

      #   post :latest_record, params: {id: @current_user.id, data: update_params }

      #   expect(response).to have_http_status(:ok)

      #   parsed_response = JSON.parse(response.body)
      #   expect(parsed_response['message']).to eq('Terms and Conditions retrieved successfully!')
      # end

      it 'returns bad request if terms are not accepted' do
        update_params = { is_accepted: false }

        post :latest_record, params: {id: @current_user.id, data: update_params }

        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Please accept terms and condition to move ahead')
      end
    end

    context 'when terms and condition not exists' do
      it 'returns not found message with status code 404' do
        BxBlockTermsAndConditions::TermsAndCondition.delete_all
        post :latest_record, params: { id: @current_user.id, data: { is_accepted: 'invalid' } }
        expect(response).to have_http_status(:not_found)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq 'terms and conditions data not found'
      end
    end
  end

  describe 'PUT #accept_and_reject' do

    context 'when terms and conditions exist' do

      context 'when is_accepted is true' do
        it 'creates or updates user term and condition and returns a success response' do
          update_params = { is_accepted: true }
          put :accept_and_reject, params: { token: @user_token, data: update_params }
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include('is_accepted' => true)
        end
      end

      context 'when is_accepted is false' do
        it 'creates or updates user term and condition and returns a success response' do
          update_params = { is_accepted: false }
          put :accept_and_reject, params: { token: @user_token, data: update_params }
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to include('is_accepted' => false)
        end
      end

      context 'when is_accepted is not true or false' do
        it 'returns an unprocessable entity response' do
          put :accept_and_reject, params: { token: @user_token, data: { is_accepted: 'invalid' } }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('message' => 'is_accepted should be either true or false.')
        end
      end
    end

    context 'when terms and condition data not exists' do
      it 'returns a not found message' do
        BxBlockTermsAndConditions::TermsAndCondition.delete_all
        put :accept_and_reject, params: { token: @user_token, data: { is_accepted: 'invalid' } }
        expect(response).to have_http_status(:not_found)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq 'Terms and Condition not found'
      end
    end
  end
end

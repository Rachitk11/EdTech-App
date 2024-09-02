# spec/models/bx_block_profile/profile_spec.rb

require 'rails_helper'

RSpec.describe BxBlockProfile::Profile, type: :model do
  before(:each) do
    role = create(:role)
    account = create(:account, role: role, full_phone_number: '8547569625')
    @profile = create(:profile, account: account)
  end
  # it "uploads a photo" do
  #   photo_path = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/index.jpeg'), 'photo/jpeg')
  #   @profile.photo = File.open(photo_path)
  #   expect(@profile.photo).to be_present
  # end
end

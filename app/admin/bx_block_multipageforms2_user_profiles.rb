module BxBlockMultipageforms2UserProfiles; end

ActiveAdmin.register BxBlockMultipageforms2::UserProfile, as: "UserProfile" do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :last_name, :phone_number, :email, :gender, :country, :industry, :message
  #
  # or
  #
  actions :all, :except => [:new, :edit, :destroy]
  # permit_params do
  #   permitted = [:first_name, :last_name, :phone_number, :email, :gender, :country, :industry, :message]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

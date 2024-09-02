ActiveAdmin.register AccountBlock::Account, as: "Publishers" do
  menu if: proc { current_admin_user.super_admin? }

  actions :all
  permit_params :first_name, :email, :full_phone_number, :user_type, :role_id, :publication_house_name, :bank_account_number, :ifsc_code
  filter :email

  controller do
    def scoped_collection
      AccountBlock::Account.joins(:role).where(roles: {name: "Publisher"})
    end

    def destroy
      publisher = AccountBlock::Account.find(params[:id])
      publisher.delete
      redirect_to :admin_publishers
    end

    after_create do |account|
      profile = BxBlockProfile::Profile.new(account_id: account.id)
      profile.user_name = account.first_name
      profile.full_phone_number = account.full_phone_number
      profile.email = account.email
      profile.publication_house_name = account.publication_house_name
      profile.save
    end
  end

  index do
    id_column
    column :name do |publisher|
      publisher.first_name
    end
    column :phone_number do |publisher|
      publisher.full_phone_number
    end
    column :role do |publisher|
      publisher.role&.name
    end
    column :email
    column :publication_house_name
    column :bank_account_number
    column :ifsc_code
    actions
  end

  show do |cs|
    attributes_table do
      row :name do |publisher|
        publisher.first_name
      end
      row :phone_number do |publisher|
        publisher.full_phone_number
      end
      row :role do |publisher|
        publisher.role&.name
      end
      row :email
      row :publication_house_name
      row :bank_account_number
      row :ifsc_code
    end
  end

  form do |f|
    f.inputs do
      f.input :role_id, as: :select, collection: BxBlockRolesPermissions::Role.where(name: "Publisher"), include_blank: false
      f.input :first_name, label: "Name", required: true
      f.input :publication_house_name
      f.input :full_phone_number, label: "Phone Number", required: true
      if !f.id.nil?
        f.input :email, required: true, input_html: {readonly: true}
      end
      f.input :email, required: true
      f.input :bank_account_number
      f.input :ifsc_code
    end
    f.actions
  end
end

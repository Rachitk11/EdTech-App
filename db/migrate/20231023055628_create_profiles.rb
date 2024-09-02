class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_profile_profiles do |t|
      t.references :account, null: false, foreign_key: true
      t.string :country
      t.string :address
      t.string :postal_code
      t.string :photo
      t.bigint "phone_number"
	    t.string "email"
	    t.string "user_name"
	    t.integer "gender"
	    t.date "date_of_birth"
	    t.integer "age"
	    t.string "teacher_unique_id"
	    t.string "guardian_email"
	    t.integer "school_id"
	    t.string "student_unique_id"
	    t.string "employee_unique_id"
	    t.string "guardian_name"
	    t.string "guardian_contact_no"
	    t.string "full_phone_number"
      t.timestamps
    end
  end
end

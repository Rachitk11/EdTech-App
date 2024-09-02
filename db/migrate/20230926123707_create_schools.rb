class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string  :name
    	t.string  :school_reg_id
    	t.string  :board
    	t.string  :phone_number
    	t.string  :email
    	t.string  :principal_name

      t.timestamps
    end
  end
end

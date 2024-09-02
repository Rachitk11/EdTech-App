class CreateSubjectManagement < ActiveRecord::Migration[6.0]
  def change
    create_table :subject_managements do |t|
    	t.integer :subject_id
    	t.integer :account_id
    	t.timestamps
    end
  end
end

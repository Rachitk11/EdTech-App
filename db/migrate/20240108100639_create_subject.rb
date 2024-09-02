class CreateSubject < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
    	t.string :subject_name
    	t.timestamps
    end
  end
end

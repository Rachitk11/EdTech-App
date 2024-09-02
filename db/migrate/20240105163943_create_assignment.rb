class CreateAssignment < ActiveRecord::Migration[6.0]
  def change
    create_table :assignments do |t|
    	t.string :title
      t.text :description
      t.string :subject
      t.timestamps
    end
  end
end

class RemoveSubjectIntoAssignment < ActiveRecord::Migration[6.0]
  def change
  	remove_column :assignments, :subject, :string
  end
end

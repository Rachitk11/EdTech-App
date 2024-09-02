class CreateStudentVideo < ActiveRecord::Migration[6.0]
  def change
    create_table :student_videos do |t|
      t.belongs_to :account
      t.belongs_to :videos_lecture
      t.boolean :status, default: false
    end
  end
end

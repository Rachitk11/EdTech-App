class CreateFaqQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :faq_questions do |t|
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end

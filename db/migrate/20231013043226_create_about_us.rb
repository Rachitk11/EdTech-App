class CreateAboutUs < ActiveRecord::Migration[6.0]
  def change
    create_table :about_us do |t|
      t.string :title
      t.string  :phone_number
      t.string  :email
      t.text :description

      t.timestamps
    end
  end
end

# This migration comes from bx_block_language_options (originally 20210226085443)
class CreateBxBlockLanguageoptionsLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :language_options_languages do |t|
      t.string :name
      t.string :language_code
      t.boolean :is_content_language
      t.boolean :is_app_language

      t.timestamps
    end unless table_exists? :language_options_languages
  end
end

# This migration comes from bx_block_language_options (originally 20210226105049)
class CreateBxBlockLanguageoptionsContentLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :contents_languages do |t|
      t.references :account, null: false, foreign_key: true
      t.references :language_options_language, null: false, foreign_key: true

      t.timestamps
    end
  end
end

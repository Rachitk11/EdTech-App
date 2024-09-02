# This migration comes from bx_block_language_options (originally 20210308074234)
class CreateApplicationMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :application_messages do |t|
      t.string :name

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        BxBlockLanguageOptions::ApplicationMessage.create_translation_table!(
          {:message => {:type => :text, :null => false}},
          {:migrate_data => true}
        )
      end

      dir.down do
        BxBlockLanguageOptions::ApplicationMessage.drop_translation_table!
      end
    end

  end
end

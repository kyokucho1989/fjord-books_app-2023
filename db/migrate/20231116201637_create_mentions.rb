class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mentioning_report, foreign_key: { to_table: :reports }
      t.references :mentioned_report, foreign_key: { to_table: :reports }
      t.timestamps
    end
  end
end

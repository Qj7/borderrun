class CreateTelegramMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_messages do |t|
      t.string :text
      t.string :telegram_id
      t.integer :message_id
      t.timestamps
    end
  end
end

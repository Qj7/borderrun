class AddTelegramIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :telegram_id, :string
    add_column :users, :telegram_nickname, :string
  end
end

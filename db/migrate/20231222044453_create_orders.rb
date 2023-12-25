class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.text :description
      t.string :trip_date
      t.references :user
      t.timestamps
    end
  end
end

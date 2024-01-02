class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :displayed_name
      t.string :status
      t.references :user
      t.timestamps
    end
  end
end

class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.text :description
      t.boolean :high_priority
      t.string :file_attachment
      t.string :status

      t.timestamps
    end
  end
end

class CreateOrderResponses < ActiveRecord::Migration
  def change
    create_table :order_responses do |t|
      t.text :response
      t.string :file_attachment

      t.timestamps
    end
  end
end

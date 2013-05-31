class CreateOrderResponseTableIds < ActiveRecord::Migration
  def up
  	add_column :order_responses, :order_id, :integer
  	add_column :order_responses, :user_id, :integer
  end

  def down
  	remove_column :order_responses, :order_id
  	remove_column :order_responses, :user_id
  end
end

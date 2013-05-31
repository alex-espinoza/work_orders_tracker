class CreateUserTableIds < ActiveRecord::Migration
  def up
  	add_column :users, :team_id, :integer
  	add_column :users, :manager_id, :integer
  end

  def down
  	remove_column :users, :team_id
  	remove_column :users, :manager_id
  end
end

class AddSchemaConstraints < ActiveRecord::Migration
  def up
  	change_column :order_responses, :response, :text, :null => false
  	change_column :order_responses, :order_id, :integer, :null => false
  	change_column :order_responses, :user_id, :integer, :null => false

  	change_column :orders, :name, :string, :null => false
  	change_column :orders, :description, :text, :null => false
  	change_column :orders, :status, :string, :null => false
  	change_column :orders, :team_id, :integer, :null => false
  	change_column :orders, :manager_id, :integer, :null => false
  	change_column :orders, :worker_id, :integer, :null => false

  	change_column :team_memberships, :role, :string, :null => false
  	change_column :team_memberships, :user_id, :integer, :null => false
  	change_column :team_memberships, :team_id, :integer, :null => false

  	change_column :teams, :team_name, :string, :null => false

  	change_column :users, :first_name, :string, :null => false
  	change_column :users, :last_name, :string, :null => false
  end

  def down
  	change_column :order_responses, :response, :text
  	change_column :order_responses, :order_id, :integer
  	change_column :order_responses, :user_id, :integer

  	change_column :orders, :name, :string
  	change_column :orders, :description, :text
  	change_column :orders, :status, :string
  	change_column :orders, :team_id, :integer
  	change_column :orders, :manager_id, :integer
  	change_column :orders, :worker_id, :integer

  	change_column :team_memberships, :role, :string
  	change_column :team_memberships, :user_id, :integer
  	change_column :team_memberships, :team_id, :integer

  	change_column :teams, :team_name, :string

  	change_column :users, :first_name, :string
  	change_column :users, :last_name, :string
  end
end

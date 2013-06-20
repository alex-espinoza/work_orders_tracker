class ChangeDataModel < ActiveRecord::Migration
  def up
  	remove_column :users, :role
  	remove_column :users, :team_id
  	remove_column :users, :manager_id

  	create_table :team_memberships do |t|
      t.string :role
      t.integer :user_id
      t.integer :team_id
      t.timestamps
    end
  end

  def down
  	add_column :users, :role, :string
  	add_column :users, :team_id, :integer
  	add_column :users, :manager_id, :integer

  	drop_table :team_memberships
  end
end

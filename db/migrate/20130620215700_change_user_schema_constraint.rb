class ChangeUserSchemaConstraint < ActiveRecord::Migration
  def up
  	change_column :users, :first_name, :string, :default => "FIRST", :null => false
  	change_column :users, :last_name, :string, :default => "LAST", :null => false
  end

  def down
  	change_column :users, :first_name, :string, :null => false
  	change_column :users, :last_name, :string, :null => false
  end
end

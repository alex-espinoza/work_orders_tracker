class ChangeTeamMembershipsSchema < ActiveRecord::Migration
  def up
  	change_column :team_memberships, :role, :string, :default => "worker", :null => false
  end

  def down
  	change_column :team_memberships, :role, :string, :null => false
  end
end

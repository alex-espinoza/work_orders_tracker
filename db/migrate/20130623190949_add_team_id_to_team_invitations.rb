class AddTeamIdToTeamInvitations < ActiveRecord::Migration
  def up
  	add_column :team_invitations, :team_id, :integer, :null => false
  end

  def down
  	remove_column :team_invitations, :team_id
  end
end

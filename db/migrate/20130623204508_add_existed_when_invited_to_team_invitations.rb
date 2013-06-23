class AddExistedWhenInvitedToTeamInvitations < ActiveRecord::Migration
  def up
  	add_column :team_invitations, :existed_when_invited, :string
  end

  def down
  	remove_column :team_invitations, :existed_when_invited
  end
end

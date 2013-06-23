class CreateTeamInvitations < ActiveRecord::Migration
  def change
    create_table :team_invitations do |t|
    	t.integer	:sender_id, :null => false
    	t.string	:recipient_email, :null => false
    	t.string	:token, :null => false
      t.timestamps
    end
  end
end

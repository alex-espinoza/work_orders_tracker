class AddInvitationTokenToUserAgain < ActiveRecord::Migration
  def up
  	add_column :users, :invitation_token, :string
  end

  def down
  	remove_column :users, :invitation_token
  end
end

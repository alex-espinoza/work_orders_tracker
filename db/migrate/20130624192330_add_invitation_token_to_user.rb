class AddInvitationTokenToUser < ActiveRecord::Migration
  def change
  	change_column_default :users, :first_name, ""
  	change_column_default :users, :last_name, ""
  end
end

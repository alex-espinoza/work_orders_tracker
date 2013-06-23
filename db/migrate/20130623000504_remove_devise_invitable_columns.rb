class RemoveDeviseInvitableColumns < ActiveRecord::Migration
  def up
  	remove_column :users, :invitation_token
  	remove_column :users, :invitation_sent_at
  	remove_column :users, :invitation_accepted_at
  	remove_column :users, :invitation_limit
  	remove_column :users, :invited_by_id
  	remove_column :users, :invited_by_type
  end

  def down
  	change_table :users do |t|
      t.string     :invitation_token, :limit => 60
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, :polymorphic => true
      t.index      :invitation_token, :unique => true # for invitable
      t.index      :invited_by_id
    end

    # And allow null encrypted_password and password_salt:
    change_column_null :users, :encrypted_password, true
  end
end

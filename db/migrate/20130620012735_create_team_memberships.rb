class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|

      t.timestamps
    end
  end
end

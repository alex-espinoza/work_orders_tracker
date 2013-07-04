class Ability
  include CanCan::Ability

  def initialize(user, params)
    # user ||= User.new

    can [:index, :new, :create], Team do
      user.id != nil
    end

    can [:show], Team do |team|
      user.team_memberships.where(team_id: team.id).length > 0
    end

    can [:new, :create], TeamInvitation do |invitation|
      team = params[:team_id]
      user.team_memberships.where(team_id: team, role: "manager").length > 0
    end

    can [:new, :create, :edit, :update, :reassign, :close, :complete], Order do |order|
      team = params[:team_id]
      user.team_memberships.where(team_id: team, role: "manager").length > 0
    end

    can [:show], Order do |order|
      user.id == order.worker.id || user.id == order.manager.id
    end

    can [:create], OrderResponse do |response|
      order = Order.find(params[:order_id])
      user.id == order.worker.id || user.id == order.manager.id
    end
  end
end

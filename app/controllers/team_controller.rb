class TeamController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def new
  end
end

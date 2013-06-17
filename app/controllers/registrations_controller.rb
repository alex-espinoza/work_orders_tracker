class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
  	if resource.role.include?("manager")
    	new_team_path
    elsif resource.role.include?("worker")
    	root_path
    end
  end
end
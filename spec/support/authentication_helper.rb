module AuthenticationHelper
	def sign_in_as(user)
		visit new_user_session_path
		fill_in "Email address", :with => user.email
		fill_in "Password", :with => user.password
		click_button "Sign In"
	end

	def sign_up_as(user)
		visit new_user_registration_path
		fill_in "First name", :with => user.first_name
		fill_in "Last name", :with => user.last_name
		fill_in "Email address", :with => user.email
		fill_in "Password", :with => user.password
		fill_in "Please type in password again", :with => user.password_confirmation
		click_button "Sign Up"
	end
end

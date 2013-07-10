if Rails.env.production?
	ActionMailer::Base.smtp_settings = {
	  :address        => "smtp.sendgrid.net",
	  :port           => 587,
	  :domain         => "heroku.com",
	  :user_name      => ENV["SENDGRID_USERNAME"],
	  :password       => ENV["SENDGRID_PASSWORD"],
	  :authentication => "plain",
	}
else
	ActionMailer::Base.smtp_settings = {
	  :address        => "smtp.gmail.com",
	  :port           => 587,
	  :domain         => "gmail.com",
	  :user_name      => "alex.espinoza.iphone@gmail.com",
	  :password       => ENV["GMAIL_PASSWORD"],
	  :authentication => "plain",
	  :enable_starttls_auto => true
	}
end

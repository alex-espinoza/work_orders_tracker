ActionMailer::Base.smtp_settings = {
	:address							=> "smtp.gmail.com",
	:port 								=> 587,
	:domain								=> "gmail.com",
	:user_name						=> "alex.espinoza.iphone@gmail.com",
	:password							=> "Forallofthis90",
	:authentication				=> "plain",
	:enable_starttls_auto	=> true
}
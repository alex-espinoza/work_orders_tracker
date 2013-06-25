class RegistrationsController < Devise::RegistrationsController

	def new_with_token
		build_resource({})
    respond_with self.resource
	end

	def new
		super
	end

	def create
		super
	end

	def cancel
		super
	end

	def edit
		super
	end

	def update
		super
	end

	def destroy
		super
	end
end

require 'spec_helper'
require 'carrierwave/test/matchers'

describe AttachmentUploader do
	include CarrierWave::Test::Matchers

	before do
		@attachment = AttachmentUploader.new(@user, :file_attachment)
		@attachment.store!(File.open(path_to_file))
	end

	after do
		@attachment.remove!
	end

	# it ""
end
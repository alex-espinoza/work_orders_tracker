require 'spec_helper'

describe AttachmentUploader do
	include CarrierWave::Test::Matchers

	before do
		AttachmentUploader.enable_processing = true
		@user = FactoryGirl.create(:valid_manager)
		@attachment = AttachmentUploader.new(@user, "#{Rails.root}/spec/carrierwave/testimg.jpg")
		@attachment.store!(File.open("#{Rails.root}/spec/carrierwave/testimg.jpg"))
	end

	after do
		AttachmentUploader.enable_processing = false
		@attachment.remove!
	end

	it "should make a thumbnail version of images attached to a new order." do
		expect(@attachment.thumb).to be_no_larger_than(250, 250)
	end

	it "should only accept image files." do
		expect(@attachment.extension_white_list).to eq(%w(jpg jpeg gif png bmp))
	end
end
class AttachmentUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay

  include CarrierWave::MiniMagick

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  include CarrierWave::MimeTypes
  process :set_content_type

  version :thumb do
    process :resize_to_fit => [250, 250]
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end
end

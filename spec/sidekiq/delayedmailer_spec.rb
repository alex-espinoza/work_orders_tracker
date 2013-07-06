require 'spec_helper'

describe Sidekiq::Extensions::DelayedMailer do
	it { should be_processed_in(:default) }
	it { should be_retryable(true) }
end
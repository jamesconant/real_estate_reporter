ENV['REAL_ESTATE_REPORT_TEST_ENV'] = 'true'

require_relative '../lib/real_estate_report'
require 'database_cleaner'

def mute_stdout
  orig_std_out = STDOUT.clone
  STDOUT.reopen('/dev/null', 'w')
  yield
  STDOUT.reopen(orig_std_out)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:suite) do
    ActiveRecord::Migration.verbose = false
  end
end

# Load dependent files
require 'active_record'
require 'pry'

require './lib/services/agent_from_json'
require './lib/services/import'

require './db/schema'

require './lib/models/agent'
require './lib/models/brokerage'
require './lib/models/property'
require './lib/models/review'
require './lib/models/sale'

require './lib/reports/top_selling_agent_per_brokerage'
require './lib/reports/top_rated_agent_per_brokerage'
require './lib/reports/top_agents_by_rating'
require './lib/reports/top_agents_by_sales'

# Setup database
test_env = ENV['REAL_ESTATE_REPORT_TEST_ENV']
if test_env && test_env == 'true'
  DATABASE_NAME = 'db/real_estate_test.db'
else
  DATABASE_NAME = 'db/real_estate.db'
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: DATABASE_NAME
)

unless File.exist?(DATABASE_NAME)
  f = File.new(DATABASE_NAME, 'w')
  f.close
  File.chmod(0777, DATABASE_NAME)
end

Schema.setup

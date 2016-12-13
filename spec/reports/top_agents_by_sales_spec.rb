require 'spec_helper'

describe TopAgentsBySales do
  describe '.print' do
    it 'prints `top 5 agents by average sale price overall` report' do
      Agent.create(first_name: 'Jon', last_name: 'Smith', average_sale_price: 1)
      Agent.create(first_name: 'Jon', last_name: 'Smith', average_sale_price: -7)

      Agent.create(first_name: 'Bob1', last_name: 'Smith', average_sale_price: 2)
      Agent.create(first_name: 'Bob2', last_name: 'Smith', average_sale_price: 3)
      Agent.create(first_name: 'Bob3', last_name: 'Smith', average_sale_price: 4)
      Agent.create(first_name: 'Bob4', last_name: 'Smith', average_sale_price: 5)
      Agent.create(first_name: 'Bob5', last_name: 'Smith', average_sale_price: 6)

      msg = <<-MESSAGE.strip_heredoc
        ## Top 5 agents by average sale price overall ##
        1. Bob5 Smith
        2. Bob4 Smith
        3. Bob3 Smith
        4. Bob2 Smith
        5. Bob1 Smith

      MESSAGE

      expect { TopAgentsBySales.print }.to output(msg).to_stdout
    end
  end
end

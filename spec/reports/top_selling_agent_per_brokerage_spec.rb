require 'spec_helper'

describe TopSellingAgentPerBrokerage do
  describe '.print' do
    it 'prints `top agent for each brokerage by average sale price` report' do
      brokerage1 = Brokerage.create(name: "Brokerage1")
      brokerage2 = Brokerage.create(name: "Brokerage2")

      Agent.create(first_name: 'Bob1', last_name: 'Smith', average_sale_price: 1, brokerage: brokerage1)
      Agent.create(first_name: 'Bob2', last_name: 'Smith', average_sale_price: 2, brokerage: brokerage1)
      Agent.create(first_name: 'Bob3', last_name: 'Smith', average_sale_price: 1, brokerage: brokerage2)
      Agent.create(first_name: 'Bob4', last_name: 'Smith', average_sale_price: 2, brokerage: brokerage2)

      msg = <<-MESSAGE.strip_heredoc
        ## Top agent for each brokerage by average sale price ##
        Brokerage1: Bob2 Smith
        Brokerage2: Bob4 Smith

      MESSAGE

      expect { TopSellingAgentPerBrokerage.print }.to output(msg).to_stdout
    end
  end
end

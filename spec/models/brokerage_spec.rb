require 'spec_helper'

describe Brokerage do
  subject { Brokerage }

  describe ".each_in_alpha_order" do
    it "yields all brokerages in case-insensitive alphabetical order" do
      brokerage1 = subject.create(name: "B")
      brokerage2 = subject.create(name: "a")
      brokerage3 = subject.create(name: "1")

      expected_brokerages = [brokerage3, brokerage2, brokerage1]

      expect { |b| subject.each_in_alpha_order(&b) }.to yield_successive_args(*expected_brokerages)
    end
  end

  describe "#top_rated_agent_name" do
    it "returns the full name of the agent with the highest average rating" do
      agent1 = Agent.create(first_name: "Bob", last_name: "Smith", average_rating: 1)
      agent2 = Agent.create(first_name: "Jon", last_name: "Smith", average_rating: 2)

      brokerage = subject.create

      brokerage.agents << [agent1, agent2]

      expect(brokerage.top_rated_agent_name).to eq("Jon Smith")
    end
  end

  describe "#top_selling_agent_name" do
    it "returns the full name of the agent with the highest average sale price" do
      agent1 = Agent.create(first_name: "Bob", last_name: "Smith", average_sale_price: 1)
      agent2 = Agent.create(first_name: "Jon", last_name: "Smith", average_sale_price: 2)

      brokerage = subject.create

      brokerage.agents << [agent1, agent2]

      expect(brokerage.top_selling_agent_name).to eq("Jon Smith")
    end
  end
end

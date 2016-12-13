require 'spec_helper'

describe Agent do
  subject { Agent }

  describe '.each_top_selling_with_rank' do
    it "yields the top 5 agents by average_sale_price and their particular ranking" do
      subject.create(first_name: 'Jon', last_name: 'Smith', average_sale_price: 1)
      subject.create(first_name: 'Jon', last_name: 'Smith', average_sale_price: -7)

      agent1 = subject.create(first_name: 'Bob1', last_name: 'Smith', average_sale_price: 2)
      agent2 = subject.create(first_name: 'Bob2', last_name: 'Smith', average_sale_price: 3)
      agent3 = subject.create(first_name: 'Bob3', last_name: 'Smith', average_sale_price: 4)
      agent4 = subject.create(first_name: 'Bob4', last_name: 'Smith', average_sale_price: 5)
      agent5 = subject.create(first_name: 'Bob5', last_name: 'Smith', average_sale_price: 6)

      expected_agents = [[agent5, 1], [agent4, 2], [agent3, 3], [agent2, 4], [agent1, 5]]

      expect { |b| subject.each_top_selling_with_rank(&b) }.to yield_successive_args(*expected_agents)
    end
  end

  describe '.each_top_rated_with_rank' do
    it "yields the top 5 agents by average_rating and their particular ranking" do
      subject.create(first_name: 'Jon', last_name: 'Smith', average_rating: 1)
      subject.create(first_name: 'Jon', last_name: 'Smith', average_rating: -7)

      agent1 = subject.create(first_name: 'Bob1', last_name: 'Smith', average_rating: 2)
      agent2 = subject.create(first_name: 'Bob2', last_name: 'Smith', average_rating: 3)
      agent3 = subject.create(first_name: 'Bob3', last_name: 'Smith', average_rating: 4)
      agent4 = subject.create(first_name: 'Bob4', last_name: 'Smith', average_rating: 5)
      agent5 = subject.create(first_name: 'Bob5', last_name: 'Smith', average_rating: 6)

      expected_agents = [[agent5, 1], [agent4, 2], [agent3, 3], [agent2, 4], [agent1, 5]]

      expect { |b| subject.each_top_rated_with_rank(&b) }.to yield_successive_args(*expected_agents)
    end
  end

  describe '.top_rated_name' do
    it "returns the full name of the agent with the highest average_rating" do
      subject.create(first_name: 'Jon', last_name: 'Smith', average_rating: 1)
      subject.create(first_name: 'Jon', last_name: 'Smith', average_rating: -3)

      agent = subject.create(first_name: 'Bob', last_name: 'Smith', average_rating: 2)

      expect(subject.top_rated_name).to eq(agent.full_name)
    end
  end

  describe '.top_selling_name' do
    it "returns the full name of the agent with the highest average_sale_price" do
      subject.create(first_name: 'Jon', last_name: 'Smith', average_sale_price: 1)
      subject.create(first_name: 'Jon', last_name: 'Smith', average_sale_price: -3)

      agent = subject.create(first_name: 'Bob', last_name: 'Smith', average_sale_price: 2)

      expect(subject.top_selling_name).to eq(agent.full_name)
    end
  end

  describe '#update_agent_average_rating' do
    context "when stuff" do
      it "updates average_rating to the current average of all their review ratings" do
        agent = subject.create(
          first_name: 'Bob',
          last_name: 'Smith',
          average_sale_price: 2,
          sales_attributes: [
            { price: 100, review_attributes: { rating: 4, content: "alksjdfl" } },
            { price: 200, review_attributes: { rating: 2, content: "alksjdfl" } }
        ])

        agent.update_column(:average_rating, 0)
        expect(agent.reload.average_rating).to eq(0)

        agent.update_average_rating
        expect(agent.reload.average_rating).to eq(3)
      end
    end
  end

  describe '#update_average_sale_price' do
    it "updates average_rating to the current average of all their sale prices" do
      agent = subject.create(
        first_name: 'Bob',
        last_name: 'Smith',
        average_sale_price: 2,
        sales_attributes: [
          { price: 100, review_attributes: { rating: 4, content: "alksjdfl" } },
          { price: 200, review_attributes: { rating: 2, content: "alksjdfl" } }
      ])

      agent.update_column(:average_sale_price, 0)
      expect(agent.reload.average_sale_price).to eq(0)

      agent.update_average_sale_price
      expect(agent.reload.average_sale_price).to eq(150)
    end
  end

  context "when a review belonging to an agent is directly updated" do
    it "triggers the average rating to be updated" do
      agent = subject.create(
        first_name: 'Bob',
        last_name: 'Smith',
        average_sale_price: 2,
        sales_attributes: [
          { price: 100, review_attributes: { rating: 4, content: "alksjdfl" } }
      ])

      expect(agent.reload.average_rating).to eq(4)

      agent.reviews.first.update(rating: 5)
      expect(agent.reload.average_rating).to eq(5)
    end
  end

  context "when a sale belonging to an agent is directly updated" do
    it "triggers the average sale price to be updated" do
      agent = subject.create(
        first_name: 'Bob',
        last_name: 'Smith',
        average_sale_price: 2,
        sales_attributes: [
          { price: 100, review_attributes: { rating: 4, content: "alksjdfl" } }
      ])

      expect(agent.reload.average_sale_price).to eq(100)

      agent.sales.first.update(price: 200)
      expect(agent.reload.average_sale_price).to eq(200)
    end
  end

  describe '#full_name' do
    context "when agent only has a first and last name" do
      it "returns their full name with a single space" do
        agent = subject.new(first_name: 'Bob', last_name: 'Smith')
        expect(agent.full_name).to eq("Bob Smith")
      end
    end

    context "when agent has a first, middle, and last name" do
      it "returns their full name with a single space" do
        agent = subject.new(first_name: 'Bob', middle_initial: 'T', last_name: 'Smith')
        expect(agent.full_name).to eq("Bob T Smith")
      end
    end
  end
end

require 'spec_helper'

describe Sale do
  subject { Sale }

  let!(:sale_with_price1) { subject.create(price: 100) }
  let!(:sale_with_price2) { subject.create(price: 200) }
  let!(:sale_without_price) { subject.create(price: nil) }

  describe ".with_price" do
    it "returns a collection of sales, all of which have prices" do
      results = subject.with_price
      expect(results.class).to eq(Sale::ActiveRecord_Relation)
      expect(results).to contain_exactly(sale_with_price1, sale_with_price2)
    end
  end

  describe ".sum_of_prices" do
    it "returns the sum of all sale prices" do
      expect(subject.sum_of_prices).to eq(300)
    end
  end

  describe "#agent_update_average_rating" do
    it "updates the average rating of a sale's agent" do
      agent = Agent.create(
        first_name: 'Jon',
        last_name: 'Smith',
        sales_attributes: [review_attributes: { rating: 1 }]
      )
      agent.update_column(:average_rating, 0)
      expect(agent.reload.average_rating).to eq(0)

      agent.sales.first.agent_update_average_rating

      expect(agent.reload.average_rating).to eq(1)
    end
  end

  describe "#agent_update_average_sale_price" do
    it "updates the average sale price of a sale's agent" do
      agent = Agent.create(
        first_name: 'Jon',
        last_name: 'Smith',
        sales_attributes: [{ price: 100 }]
      )
      agent.update_column(:average_sale_price, 0)
      expect(agent.reload.average_sale_price).to eq(0)

      agent.sales.first.agent_update_average_sale_price

      expect(agent.reload.average_sale_price).to eq(100)
    end
  end
end

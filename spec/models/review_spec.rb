require 'spec_helper'

describe Review do
  subject { Review }

  let!(:review_with_rating1) { subject.create(rating: 1) }
  let!(:review_with_rating2) { subject.create(rating: 2) }
  let!(:review_without_rating) { subject.create(rating: nil) }

  describe ".with_rating" do
    it "returns a collection of reviews, all of which have ratings" do
      results = subject.with_rating
      expect(results.class).to eq(Review::ActiveRecord_Relation)
      expect(results).to contain_exactly(review_with_rating1, review_with_rating2)
    end
  end

  describe ".sum_of_ratings" do
    it "returns the sum of all review ratings" do
      expect(subject.sum_of_ratings).to eq(3)
    end
  end

  describe "#sale_agent_update_average_rating" do
    it "updates the average rating of a sale's agent" do
      agent = Agent.create(
        first_name: 'Jon',
        last_name: 'Smith',
        sales_attributes: [review_attributes: { rating: 1 }]
      )
      agent.update_column(:average_rating, 0)
      expect(agent.reload.average_rating).to eq(0)

      agent.reviews.first.sale_agent_update_average_rating

      expect(agent.reload.average_rating).to eq(1)
    end
  end
end

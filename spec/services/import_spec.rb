require 'spec_helper'

describe Import do
  describe '.from_file' do
    it 'creates or updates records based on the file contents' do
      # For the sake of test suite performance, all of these related
      # expectations were kept in one test.

      Agent.create(
        first_name: 'Bob',
        last_name: 'Smith',
        middle_initial: 'A',
        brokerage_attributes: { name: 'Brokerage1' }
      )

      expect(Agent.count).to eq(1)
      expect(Brokerage.count).to eq(1)
      expect(Sale.count).to eq(0)
      expect(Review.count).to eq(0)
      expect(Property.count).to eq(0)

      Import.from_file('./spec/fixtures/import_data.json')

      expect(Agent.count).to eq(2)
      expect(Brokerage.count).to eq(1)
      expect(Sale.count).to eq(2)
      expect(Review.count).to eq(2)
      expect(Property.count).to eq(2)

      agent1 = Agent.find_by(first_name: 'Bob')

      expect(agent1.last_name).to eq('Smith')
      expect(agent1.middle_initial).to eq('A')

      expect(agent1.brokerage.name).to eq('Brokerage1')

      expect(agent1.sales.first.price).to eq(1000)

      expect(agent1.sales.first.property.address).to eq('321 Side St')
      expect(agent1.sales.first.property.unit).to eq('Apt. 2')
      expect(agent1.sales.first.property.city).to eq('Centerville')
      expect(agent1.sales.first.property.state).to eq('NY')
      expect(agent1.sales.first.property.zip_code).to eq('12345-2222')
      expect(agent1.sales.first.property.mls_id).to eq('676239872983')

      expect(agent1.sales.first.review.content).to eq('Bob was great.')
      expect(agent1.sales.first.review.rating).to eq(10)

      agent2 = Agent.find_by(first_name: 'Jon')

      expect(agent2.last_name).to eq('Smith')
      expect(agent2.middle_initial).to eq('A')

      expect(agent2.brokerage.name).to eq('Brokerage1')

      expect(agent2.sales.first.price).to eq(2000)

      expect(agent2.sales.first.property.address).to eq('123 Main St')
      expect(agent2.sales.first.property.unit).to eq('Apt. 1')
      expect(agent2.sales.first.property.city).to eq('Centerville')
      expect(agent2.sales.first.property.state).to eq('NY')
      expect(agent2.sales.first.property.zip_code).to eq('12345-1111')
      expect(agent2.sales.first.property.mls_id).to eq('987418274921')

      expect(agent2.sales.first.review.content).to eq('Jon was terrible.')
      expect(agent2.sales.first.review.rating).to eq(1)
    end
  end
end

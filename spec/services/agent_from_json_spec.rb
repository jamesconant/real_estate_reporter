require 'spec_helper'

describe AgentFromJson do
  describe '#update_or_create' do
    shared_examples 'record import succeeded' do
      it "successfully imports records" do
        agent = Agent.find_by(first_name: 'Bob')

        expect(Agent.count).to eq(1)
        expect(Brokerage.count).to eq(1)
        expect(Sale.count).to eq(1)
        expect(Review.count).to eq(1)
        expect(Property.count).to eq(1)

        expect(agent.first_name).to eq('Bob')
        expect(agent.last_name).to eq('Smith')
        expect(agent.middle_initial).to eq('A')

        expect(agent.brokerage.name).to eq('Brokerage1')

        expect(agent.sales.first.price).to eq(1000)

        expect(agent.sales.first.property.address).to eq('321 Side St')
        expect(agent.sales.first.property.unit).to eq('Apt. 2')
        expect(agent.sales.first.property.city).to eq('Centerville')
        expect(agent.sales.first.property.state).to eq('NY')
        expect(agent.sales.first.property.zip_code).to eq('12345-2222')
        expect(agent.sales.first.property.mls_id).to eq('676239872983')

        expect(agent.sales.first.review.content).to eq('Bob was great.')
        expect(agent.sales.first.review.rating).to eq(10)
      end
    end

    let(:json_as_hash) do
      {
        "sale" => {
          "agent" => {
            "agent" => {
              "first_name" => "Bob",
              "last_name" => "Smith",
              "middle_initial" => "A",
              "brokerage" => "Brokerage1"
            }
          },
          "price" => 1000,
          "property" => {
            "property" => {
              "address" => "321 Side St",
              "city" => "Centerville",
              "id" => "676239872983",
              "state" => "NY",
              "unit" => "Apt. 2",
              "zip_code" => "12345-2222"
            }
          },
          "review" => {
            "review" => {
              "content" => "Bob was great.",
              "rating" => 10
            }
          }
        }
      }
    end

    context 'when agent already exists' do
      before do
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

        AgentFromJson.new(json_as_hash).update_or_create
      end

      it_behaves_like 'record import succeeded'
    end

    context 'when agent does not already exist' do
      before do
        expect(Agent.count).to eq(0)
        expect(Brokerage.count).to eq(0)
        expect(Sale.count).to eq(0)
        expect(Review.count).to eq(0)
        expect(Property.count).to eq(0)

        AgentFromJson.new(json_as_hash).update_or_create
      end

      it_behaves_like 'record import succeeded'
    end
  end
end

class Schema
  def self.setup
    ActiveRecord::Schema.define do
      unless ActiveRecord::Base.connection.data_sources.include?('agents')
        create_table :agents do |t|
          t.string :first_name
          t.string :last_name
          t.string :middle_initial
          t.integer :brokerage_id
          t.integer :average_rating
          t.integer :average_sale_price
        end
      end

      unless ActiveRecord::Base.connection.data_sources.include?('brokerages')
        create_table :brokerages do |t|
          t.string :name
        end
      end

      unless ActiveRecord::Base.connection.data_sources.include?('properties')
        create_table :properties do |t|
          t.string :address
          t.string :unit
          t.string :city
          t.string :state
          t.string :zip_code
          t.string :mls_id
          t.integer :sale_id
        end
      end

      unless ActiveRecord::Base.connection.data_sources.include?('reviews')
        create_table :reviews do |t|
          t.string :content
          t.integer :rating
          t.integer :sale_id
        end
      end

      unless ActiveRecord::Base.connection.data_sources.include?('sales')
        create_table :sales do |t|
          t.integer :price
          t.integer :agent_id
        end
      end
    end
  end
end

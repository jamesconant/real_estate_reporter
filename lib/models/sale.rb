class Sale < ActiveRecord::Base
  belongs_to :agent
  has_one :property
  has_one :review

  accepts_nested_attributes_for :property, :review

  # This ensures that if a sale is updated directly,
  # the agent's average sale price is also updated
  after_update :agent_update_average_sale_price

  scope :with_price, -> { where.not(price: nil) }

  def self.sum_of_prices
    sum(:price)
  end

  delegate :update_average_rating, to: :agent, prefix: true
  delegate :update_average_sale_price, to: :agent, prefix: true
end

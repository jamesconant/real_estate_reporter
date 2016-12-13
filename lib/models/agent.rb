class Agent < ActiveRecord::Base
  belongs_to :brokerage
  has_many :sales
  has_many :reviews, through: :sales

  accepts_nested_attributes_for :brokerage, :sales

  after_save :update_average_rating, :update_average_sale_price

  def self.each_top_selling_with_rank
    order(average_sale_price: :desc).limit(5).each_with_index do |agent, ii|
      yield agent, ii + 1
    end
  end

  def self.each_top_rated_with_rank
    order(average_rating: :desc).limit(5).each_with_index do |agent, ii|
      yield agent, ii + 1
    end
  end

  def self.top_rated_name
    where.not(average_rating: nil).max_by(&:average_rating).try(:full_name)
  end

  def self.top_selling_name
    where.not(average_sale_price: nil).max_by(&:average_sale_price).try(:full_name)
  end

  def update_average_rating
    if reviews.with_rating.count > 0
      self.update_column(:average_rating, reviews.sum_of_ratings / reviews.with_rating.count)
    end
  end

  def update_average_sale_price
    if sales.with_price.count > 0
      self.update_column(:average_sale_price, sales.sum_of_prices / sales.with_price.count)
    end
  end

  def full_name
    [first_name, middle_initial, last_name].compact.join(' ')
  end
end

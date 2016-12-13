class Review < ActiveRecord::Base
  belongs_to :sale

  # This ensures that if a review is updated directly,
  # the agent's average rating is also updated
  after_update :sale_agent_update_average_rating

  scope :with_rating, -> { where.not(rating: nil) }

  def self.sum_of_ratings
    sum(:rating)
  end

  delegate :agent_update_average_rating, to: :sale, prefix: true
end

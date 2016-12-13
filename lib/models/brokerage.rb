class Brokerage < ActiveRecord::Base
  has_many :agents

  def self.each_in_alpha_order
    order("lower(name) ASC").each do |brokerage|
      yield brokerage
    end
  end

  def top_rated_agent_name
    agents.top_rated_name
  end

  def top_selling_agent_name
    agents.top_selling_name
  end
end

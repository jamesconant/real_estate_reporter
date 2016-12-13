class TopRatedAgentPerBrokerage
  def self.print
    puts '## Top agent for each brokerage by average rating ##'

    Brokerage.each_in_alpha_order do |brokerage|
      puts "#{brokerage.name}: #{brokerage.top_rated_agent_name}"
    end

    puts "\n"
  end
end

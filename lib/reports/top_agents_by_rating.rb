class TopAgentsByRating
  def self.print
    puts '## Top 5 agents by average rating overall ##'

    Agent.each_top_rated_with_rank do |agent, rank|
      puts "#{rank}. #{agent.full_name}"
    end

    puts "\n"
  end
end

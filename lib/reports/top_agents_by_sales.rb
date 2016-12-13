class TopAgentsBySales
  def self.print
    puts '## Top 5 agents by average sale price overall ##'

    Agent.each_top_selling_with_rank do |agent, rank|
      puts "#{rank}. #{agent.full_name}"
    end

    puts "\n"
  end
end

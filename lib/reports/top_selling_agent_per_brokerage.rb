class TopSellingAgentPerBrokerage
  def self.print
    puts '## Top agent for each brokerage by average sale price ##'

    Brokerage.each_in_alpha_order do |brokerage|
      puts "#{brokerage.name}: #{brokerage.top_selling_agent_name}"
    end

    puts "\n"
  end
end

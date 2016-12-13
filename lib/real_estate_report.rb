require_relative '../config'

class RealEstateReport
  REPORTS = [
    TopAgentsBySales,
    TopAgentsByRating,
    TopSellingAgentPerBrokerage,
    TopRatedAgentPerBrokerage
  ]

  def self.print_report(files = [])
    files.each { |file| Importer.import_file(file) }
    REPORTS.each(&:print)
  end
end

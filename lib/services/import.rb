class Import
  def self.from_file(file_path)
    if file_path && File.exist?(file_path)
      JSON.parse(File.read(file_path)).each do |json|
        AgentFromJson.new(json).update_or_create
      end
    end
  end
end

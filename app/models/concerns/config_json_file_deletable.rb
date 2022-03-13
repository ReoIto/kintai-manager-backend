module ConfigJsonFileDeletable
  extend ActiveSupport::Concern

  CONFIG_FILE_NAME = ENV['CONFIG_FILE_NAME']

  def delete_config_file
    File.delete(CONFIG_FILE_NAME) if File.exist?(CONFIG_FILE_NAME)
  end
end
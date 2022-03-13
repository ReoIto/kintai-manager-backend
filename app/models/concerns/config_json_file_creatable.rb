module ConfigJsonFileCreatable
  extend ActiveSupport::Concern

  CONFIG_FILE_NAME = ENV['CONFIG_FILE_NAME']

  def create_config_file
    file = File.open(CONFIG_FILE_NAME,"w")
    config_hash = {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      scope: [
        ENV['SCOPE_ONE'],
        ENV['SCOPE_TWO']
      ],
      refresh_token: ENV['REFRESH_TOKEN']
    }

    file.write(config_hash.to_json)
    file.close

    CONFIG_FILE_NAME
  end
end
class CopyTemplateSheet
  TEMPLATE_SHEET_TITLE = ENV['TEMPLATE_SHEET_TITLE']

  # とりあえずコンソールから手動で叩く想定で作成
  # ex) CopyTemplateSheet.new.perform year:2022, month:2
  def perform year:, month:
    session = GoogleDrive::Session.from_config(create_config_file)
    template_sheet = session.spreadsheet_by_title(TEMPLATE_SHEET_TITLE)
    copied_sheet = template_sheet.copy("#{year}年#{month}月集計分")
    delete_config_file
  end

  private
  # todo
  # 以下2つのメソッドはDRYじゃない(UpdateSpreadSheetにもある)
  # Utilから呼び出せるようにする
  def create_config_file
    file = File.open(UpdateSpreadSheet::CONFIG_FILE_NAME,"w")
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

    UpdateSpreadSheet::CONFIG_FILE_NAME
  end

  def delete_config_file
    File.delete(CONFIG_FILE_NAME) if File.exist?(CONFIG_FILE_NAME)
  end
end
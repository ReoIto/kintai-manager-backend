class CopyTemplateSheet
  include ConfigJsonFileCreatable
  include ConfigJsonFileDeletable

  TEMPLATE_SHEET_TITLE = ENV['TEMPLATE_SHEET_TITLE']

  # とりあえずコンソールから手動で叩く想定で作成
  # ex) CopyTemplateSheet.new.perform year:2022, month:2
  def perform year:, month:
    session = GoogleDrive::Session.from_config(create_config_file)
    template_sheet = session.spreadsheet_by_title(TEMPLATE_SHEET_TITLE)
    copied_sheet = template_sheet.copy("#{year}年#{month}月集計分")
    delete_config_file if copied_sheet.present?
  end
end
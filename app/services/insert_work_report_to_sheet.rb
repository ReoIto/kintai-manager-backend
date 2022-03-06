class InsertWorkReportToSheet
  include BaseService
  KEY = ENV['KEY']

  def initialize driver, inserting_row_hash, session
    @driver = driver
    @inserting_row_hash = inserting_row_hash
    @session = session
  end

  def call
    inserted_sheet = session.spreadsheet_by_key(KEY).worksheet_by_title("test-#{driver.name}")
    row_num = inserted_sheet.num_rows + 1

    inserting_row_hash.values.each.with_index(1) do |element, i|
      col_num = i
      inserted_sheet[row_num, col_num] = element
      col_num += 1
    end
    inserted_sheet
  end

  private
  attr_reader :driver, :inserting_row_hash, :session
end
class InsertWorkReportToSheet
  include BaseService

  def initialize work_report, inserting_row_hash, session
    @work_report = work_report
    @inserting_row_hash = inserting_row_hash
    @session = session
  end

  def call
    driver = work_report.driver
    inserted_sheet = session
      .spreadsheet_by_title(sheet_title)
      .worksheet_by_title(driver.name)

    row_num = inserted_sheet.num_rows + 1
    inserting_row_hash.values.each.with_index(1) do |element, i|
      col_num = i
      inserted_sheet[row_num, col_num] = element
      col_num += 1
    end
    inserted_sheet
  end

  private
  attr_reader :work_report, :inserting_row_hash, :session

  def sheet_title
    working_year = work_report.date.year
    working_month = work_report.date.month
    sheet_title = "#{working_year}年#{working_month}月集計分"
  end
end
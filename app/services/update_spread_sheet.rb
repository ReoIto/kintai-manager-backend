class UpdateSpreadSheet
  require "google_drive"

  include BaseService
  include ConfigJsonFileCreatable
  include ConfigJsonFileDeletable

  WRS_NAME = ENV['WORK_REPORT_SHEET_NAME']
  KEY = ENV['KEY']
  STATUS_COL_NUM = ENV['STATUS_COL_NUM'].to_i
  OK = 'OK'
  ERROR = 'ERROR'

  def initialize
    @session = GoogleDrive::Session.from_config(create_config_file)
    @work_report_sheet = session.spreadsheet_by_key(KEY).worksheet_by_title(WRS_NAME)
    @work_report = nil
    @fixed_salary = nil
  end

  def call
    wrs_rows = work_report_sheet.rows
    wrs_rows = wrs_rows.dup
    wrs_rows.delete_at(0)

    # スプレッドシート1行目はヘッダーのため、2行目からeachを始める
    wrs_rows.each.with_index(2) do |row, i|
      ActiveRecord::Base.transaction do
        row_num = i
        next if work_report_sheet[row_num, STATUS_COL_NUM] == OK
        next if work_report_sheet[row_num, STATUS_COL_NUM] == ERROR

        target_row_hash = {
          name: row[1],
          date: row[2],
          code: row[3],
          guests: row[4],
          departure_point: row[5],
          destination_point: row[6],
          departure_time: row[7],
          arrival_time: row[8],
          job_number: row[9],
          description: row[10],
          one_way_kilo_range: row[12]
        }

        create_work_report_result = CreateWorkReport.call target_row_hash

        if create_work_report_result.success?
          work_report = create_work_report_result.data
        else
          errors = create_work_report_result.errors
          update_sheet_to_error!(row_num)

          raise StandardError,
            "Can\'t create work_report : #{errors} \n Params : #{target_row_hash}"
        end

        create_fixed_report_result = CreateFixedSalary.call work_report

        if create_fixed_report_result.success?
          fixed_salary = create_fixed_report_result.data
        else
          errors = create_fixed_report_result.errors
          update_sheet_to_error!(row_num)

          raise StandardError,
            "Can\'t create fixed_salary : #{errors} \n Params : #{target_row_hash}"
        end

        inserting_row_hash = BuildInsertingRowHash.call work_report, fixed_salary
        ValidateInsertingRow.call inserting_row_hash

        inserted_sheet =
          InsertWorkReportToSheet.call work_report, inserting_row_hash, session

        if inserted_sheet.save
          update_sheet_to_ok!(row_num)
          success_result_logger(target_row_hash, work_report)
        end
        # GoogleAPIの1分間の通信回数の制限を上回ることがあるため
        # スプレッドシートの更新を行った場合は2秒間sleepさせて遅らせる
        sleep 2
      end
    rescue StandardError, ActiveRecord::RecordNotFound => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace.join("\n")
    ensure
      delete_config_file
    end
  end

  private
  attr_reader :session, :work_report_sheet, :work_report, :fixed_salary

  def update_sheet_to_ok! row_num
    work_report_sheet[row_num,STATUS_COL_NUM] = OK
    work_report_sheet.save
  end

  def update_sheet_to_error! row_num
    work_report_sheet[row_num,STATUS_COL_NUM] = ERROR
    work_report_sheet.save
  end

  def success_result_logger hash, work_report
    ResultLogger.new(hash, work_report).success
  end
end

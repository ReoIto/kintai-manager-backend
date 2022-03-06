class ResultLogger
  include BaseService

  def initialize target_row_hash, work_report
    @target_row_hash = target_row_hash
    @work_report = work_report
    @fixed_salary = work_report.fixed_salary
  end

  def success
    Rails.logger.info "Success updating sheet with"
    Rails.logger.info "TargetRowHash: #{target_row_hash}"
    Rails.logger.info "TimeStamp:#{Time.now},
                        Driver: #{work_report.driver.name},
                        WorkReportId: #{work_report.id},
                        Date: #{work_report.date},
                        Code: #{work_report.code},
                        JobNumber: #{work_report.job_number},
                        FixedSalryId: #{fixed_salary.id},
                        TotalFixedSalary: #{fixed_salary.total}
                        ----------------------------------------
                      "
  end

  private
  attr_reader :target_row_hash, :work_report, :fixed_salary, :errors
end
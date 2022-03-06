# FixedSalaryをsaveする上で必要なデータを集める。saveする
# 計算処理はCalcurateSalaryに任せる

class CreateFixedSalary
  include BaseService

  def initialize work_report
    @work_report = work_report
  end

  def call
    driver = work_report.driver
    total_salary = CalcurateSalary.call driver, work_report

    unless total_salary
      return ServiceResult.new success: false, errors: 'Can\'t calcurate fixed_salary'
    end

    fixed_salary = FixedSalary.create(
      total: total_salary,
      work_report_id: work_report.id,
    )

    errors = fixed_salary.errors.messages
    if errors.blank?
      ServiceResult.new success: true, data: fixed_salary
    else
      ServiceResult.new success: false, errors: errors
    end
  end

  private
  attr_reader :work_report
end
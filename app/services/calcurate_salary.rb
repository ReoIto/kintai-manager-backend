class CalcurateSalary
  include BaseService

  JOB_1_BASE_SALARY = 5000
  JOB_2_BASE_SALARY = 6000
  JOB_3_BASE_SALARY = 4000
  JOB_4_BASE_SALARY_PER_HOUR = 4000
  JOB_5_BASE_SALARY_PER_HOUR = 4000

  def initialize driver, work_report
    @driver = driver
    @work_report = work_report
    @base_extra = find_base_extra
    @per_kilo_extra = find_per_kilo_extra
    @working_minutes = work_report.calc_working_minutes
    @one_way_kilo_range = work_report.one_way_kilo_range
  end

  # returns total_salary(int)
  def call
    case work_report.job_number
    when 1
      JOB_1_BASE_SALARY + base_extra
    when 2
      JOB_2_BASE_SALARY + base_extra
    when 3
      if driver.id == 1
        if working_minutes >= 60
          per_kilo_extra * one_way_kilo_range
        else
          JOB_3_BASE_SALARY + base_extra
        end
      else
        if working_minutes < 60
          JOB_3_BASE_SALARY + base_extra
        else
          over_time_extra = over_time_extra(working_minutes)
          JOB_3_BASE_SALARY + base_extra + over_time_extra
        end
      end
    when 4, 5
      if working_minutes < 76
        driver.minimum_guaranteed_salary
      else
        hourly_pay = driver.hourly_pay
        per_minute_pay = (hourly_pay / 60r).ceil(2).to_f #----- 4000の場合、1分当たり66.67円
        per_minute_pay * working_minutes
      end
    end
  end

  private
  attr_reader :driver, :work_report, :base_extra, :per_kilo_extra, :working_minutes, :one_way_kilo_range

  def find_base_extra
    driver.extra_salaries.find_by(
      is_base_extra: true,
      job_number: work_report.job_number
    )&.amount || 0
  end

  def find_per_kilo_extra
    driver.extra_salaries.find_by(
      is_range_extra: true,
      job_number: work_report.job_number
    )&.amount || 0
  end

  def find_over_time_extra minutes
    ExtraSalary.find_by(
      driver_id: driver.id,
      over_time_minutes: minutes,
      is_base_extra: false
    )&.amount || 0
  end

  def over_time_extra working_minutes
    case working_minutes
      when 60..119
        find_over_time_extra(60)
      when 120..179
        find_over_time_extra(120)
      when 180..239
        find_over_time_extra(180)
      when 240..999
        find_over_time_extra(240)
      end
  end
end
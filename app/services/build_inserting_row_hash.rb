class BuildInsertingRowHash
  include BaseService

  def initialize work_report, fixed_salary
    @work_report = work_report
    @fixed_salary = fixed_salary
  end

  def call
    inserting_row_hash = {
      time_stamp: Time.current,
      driver_name: work_report.driver.name,
      date: work_report.date.to_s,
      code: work_report.code,
      guests: work_report.guests,
      departure_point: work_report.departure_point,
      destination_point: work_report.destination_point,
      job_number: work_report.job_number,
      formatted_departure_time: work_report.departure_time.strftime("%T"),
      formatted_arrival_time: work_report.arrival_time.strftime("%T"),
      formatted_working_time: work_report.formatted_working_time,
      one_way_kilo_mater: work_report.one_way_kilo_range,
      total_fixed_salary: fixed_salary.total,
      description: work_report.description
    }
  end

  private
  attr_reader :work_report, :fixed_salary
end
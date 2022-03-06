class ValidateInsertingRow
  include BaseService

  REQUIRED_VALUES =
    %w(
      time_stamp driver_name date code guests
      departure_point destination_point job_number
      formatted_departure_time formatted_arrival_time
      formatted_working_time total_fixed_salary
    )

  def initialize inserting_row_hash
    @inserting_row_hash = inserting_row_hash
  end

  def call
    # 必須valueが全て存在するか
    REQUIRED_VALUES.each do |val|
      unless check_required_value(val, inserting_row_hash)
        raise StandardError, "Missing RequiredValue value : #{val}, hash : #{inserting_row_hash}"
      end
    end
    # inserting_row_hash be like:
    #
    # inserting_row_hash = {
    #   time_stamp: Time.current,
    #   driver_name: work_report.driver.name,
    #   date: work_report.date,
    #   code: work_report.code,
    #   guests: work_report.guests,
    #   departure_point: work_report.departure_point,
    #   destination_point: work_report.destination_point,
    #   job_number: work_report.job_number,
    #   formatted_departure_time: work_report.departure_time.strftime("%T"),
    #   formatted_arrival_time: work_report.arrival_time.strftime("%T"),
    #   formatted_working_time: work_report.formatted_working_time,
    #   one_way_kilo_mater: work_report.one_way_kilo_range,
    #   total_fixed_salary: fixed_salary.total,
    #   description: work_report.description
    # }
  end

  private
  attr_reader :inserting_row_hash

  def check_required_value val, inserting_row_hash
    inserting_row_hash[val.to_sym].present?
  end
end
class CreateWorkReport
  include BaseService

  def initialize row
    @name = row[:name]
    @date = row[:date]
    @code = row[:code]
    @guests = row[:guests].presence || ''
    @departure_point = row[:departure_point]
    @destination_point = row[:destination_point]
    @departure_time = row[:departure_time]
    @arrival_time = row[:arrival_time]
    @job_number = row[:job_number]
    @description = row[:description]
    @one_way_kilo_range = row[:one_way_kilo_range]
    @formatted_working_time = nil
    @formatted_departure_time = nil
    @formatted_arrival_time = nil
  end

  def call
    driver = Driver.find_by(name: name)
    unless driver
      return ServiceResult.new success: false, errors: [ActiveRecord::RecordNotFound, name]
    end

    calc_and_format_time_rows

    work_report = driver.work_reports.create(
      name: driver.name,
      date: date.to_date,
      code: code,
      guests: guests,
      departure_point: departure_point,
      destination_point: destination_point,
      departure_time: formatted_departure_time,
      arrival_time: formatted_arrival_time,
      job_number: job_number.to_i,
      description: description,
      formatted_working_time: formatted_working_time,
      one_way_kilo_range: one_way_kilo_range&.to_i
    )

    errors = work_report.errors.messages
    if errors.blank?
      ServiceResult.new success: true, data: work_report
    else
      ServiceResult.new success: false, errors: errors
    end
  end

  private
  attr_reader :name, :date, :code, :guests, :departure_point, :destination_point,
    :departure_time, :arrival_time, :job_number, :description,
    :formatted_working_time, :one_way_kilo_range, :formatted_working_time,
    :formatted_departure_time, :formatted_arrival_time

  def calc_and_format_time_rows
    @formatted_working_time = calc_and_format_working_time
    @formatted_departure_time = departure_time.to_time.strftime("%T")
    @formatted_arrival_time = arrival_time.to_time.strftime("%T")
  end

  def calc_and_format_working_time
    # be like 4200 -> "01:10:00"
    working_sec = calc_working_sec
    Time.at(Time.at(working_sec).getutc).strftime('%T')
  end

  def calc_working_sec
    arrival_time.to_time - departure_time.to_time
  end
end

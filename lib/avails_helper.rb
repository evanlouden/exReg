module AvailsHelper
  def clear_times(availabilities)
    availabilities.each do |a|
      next unless a.checked == "0"
      a.start_time = nil
      a.end_time   = nil
      a.save
    end
  end

  def avails_hash(arg)
    unless arg.nil?
      load_avails(arg)
      sorted_avails = sort_avails(@avails)
      format_avails_hash(sorted_avails)
    end
  end

  def sort_avails(array)
    days = Availability::DAYS
    lookup = {}

    days.each_with_index do |day, index|
      lookup[day] = index
    end

    array.sort_by do |item|
      lookup.fetch(item.day)
    end
  end

  def load_avails(arg)
    @avails = if arg.is_a? String
                Inquiry.find(params[:inquiry]).student.availabilities
              else
                arg
              end
  end

  def format_avails_hash(avails)
    availabilities = {}
    avails.each do |a|
      time_hash = {}
      time_hash[:start_time] = a.start_time
      time_hash[:end_time]   = a.end_time
      availabilities[a.day]  = time_hash
    end
    availabilities
  end
end

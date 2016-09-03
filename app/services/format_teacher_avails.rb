class FormatTeacherAvails
  extend SortHelpers
  def self.call(avails)
    sorted_avails = sort_avails(avails)
    availabilities = {}
    sorted_avails.each do |a|
      time_hash = {}
      time_hash[:start_time] = a.start_time
      time_hash[:end_time]   = a.end_time
      availabilities[a.day]  = time_hash
    end
    availabilities
  end
end

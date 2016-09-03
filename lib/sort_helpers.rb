module SortHelpers
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
end

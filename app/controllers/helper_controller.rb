class HelperController < ApplicationController
  def any_selected?(array)
    array.each do |a|
      return false if a.checked == "1"
    end
    return true
  end
end

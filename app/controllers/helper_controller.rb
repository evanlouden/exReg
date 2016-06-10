class HelperController < ApplicationController
  def checkbox_verify(array)
    array.collect { |item| item.delete if item.checked == "0" || item.invalid_time? }
  end
end

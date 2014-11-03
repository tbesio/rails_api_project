require 'open-uri'
require 'json'

class ForecastsController < ApplicationController
  def location

    render 'location'
  end
end

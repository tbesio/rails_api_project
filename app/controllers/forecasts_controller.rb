require 'open-uri'
require 'json'

class ForecastsController < ApplicationController
  def location
    url_safe_address = params["address"]
    # Used a gsub to make the URL safe addreess better for output by substituting a space wherever there is a +.
    @output_address = url_safe_address.gsub(/[+]/, ' ')

    # Paste forecast.io API key here if it changes for some reason.
    api_key = "e937af7b7f9792ee1b197a54684d46e2"+"/"
    forecast_io_api_url = "https://api.forecast.io/forecast/"

    # Create the api address with the API key included.
    forecast_io_api_w_key = forecast_io_api_url + api_key

    # Pass the address to the google geocoder API
    maps_api_base_address = "http://maps.googleapis.com/maps/api/geocode/json?address="
    maps_api_request_address = maps_api_base_address+url_safe_address

    parsed_maps_result = JSON.parse(open(maps_api_request_address).read)
    maps_address_result = parsed_maps_result["results"][0]

    # Let's store the latitude in a variable called 'the_latitude',
    #   and the longitude in a variable called 'the_longitude'.

    the_latitude = maps_address_result["geometry"]["location"]["lat"]
    @output_latitude = the_latitude
    the_longitude = maps_address_result["geometry"]["location"]["lng"]
    @output_longitude = the_longitude

    # Create a url to pass to forecast.io API with the LAT/LON pair included.
    api_call_url = forecast_io_api_w_key + the_latitude.to_s + "," + the_longitude.to_s

    # Send a call to the server for forecast data at the LAT/LON pair. Store the result as api_call_result.
    api_call_result = JSON.parse(open(api_call_url).read)

    @the_temperature = api_call_result["currently"]["temperature"]
    @the_hour_outlook = api_call_result["minutely"]["summary"]
    @the_day_outlook = api_call_result["hourly"]["summary"]

    render 'location'
  end
end

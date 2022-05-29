# frozen_string_literal: true

BASE_URL = 'https://weather.tsukumijima.net/api/forecast'
AREA_CODE_YOKOHAMA = 140010

conn = Faraday.new(url: BASE_URL)

SCHEDULER.every '1d', :first_in => 0 do |job|
  data = nil

  res = JSON.parse(conn.get('/api/forecast', { city: AREA_CODE_YOKOHAMA }).body, symbolize_names: true)
  forecasts = res[:forecasts]
  description = res[:description][:text]

  send_event('weather_today', data: forecasts[0])
  send_event('weather_tomorrow', data: forecasts[1])
  send_event('weather_description', data: description)
end
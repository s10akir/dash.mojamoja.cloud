# frozen_string_literal: true

DEVICE_NAME = 'cthugha'
conn = Faraday.new(url: "http://#{CTHUGHA_IP}")

SCHEDULER.every '1m', :first_in => 0 do
  puts '[INFO] start cthugha job'
  res = JSON.parse(conn.get('/').body, symbolize_names: true)

  data = {
    name: DEVICE_NAME,
    temperature: res[:data][:temperature],
    humidity: res[:data][:humidity],
  }

  send_event("#{DEVICE_NAME}", data: data)
end

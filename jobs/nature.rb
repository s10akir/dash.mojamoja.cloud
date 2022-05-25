conn = Faraday.new(url: "https://api.nature.global") do |faraday|
  faraday.request :authorization, :Bearer, NATURE_TOKEN
end

SCHEDULER.every '1m', :first_in => 0 do
  puts '[INFO] start nature job'
  res = conn.get('/1/devices')

  JSON.parse(res.body, symbolize_names: true).each do |event|
    data = {
      name: event[:name],
      temperature: event[:newest_events][:te][:val]
    }

    # Remo mini には湿度計がない
    data[:humidity] = event[:newest_events][:hu][:val] if (event[:newest_events][:hu])

    send_event("nature_#{event[:name]}", data: data)
  end
end

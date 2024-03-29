class BandTown

  def initialize
    @conn = Faraday.new(:url => 'http://api.bandsintown.com') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def upcomming_week

  end

  def usa_events(location)
    response = @conn.get do |req|
      # req.url "/events/search?location=#{location}&radius=40&date=#{14.days.from_now.strftime("%Y-%m-%d")}&per_page=25&format=json"
      req.url "/events/search?location=#{location}&radius=40&date=#{DateTime.now.next_week.strftime("%Y-%m-%d")},#{DateTime.now.next_week.next_day(6).strftime("%Y-%m-%d")}&per_page=50&format=json"
      req.params['app_id'] = ENV["BANDS_ID"]
    end
    events = JSON.parse(response.body)
    events.map do |event|
      event
    end
  end

end

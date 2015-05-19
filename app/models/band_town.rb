class BandTown

  def initialize
    @conn = Faraday.new(:url => 'http://api.bandsintown.com') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def usa_events(location)
    response = @conn.get do |req|
      req.url "/events/search?location=#{location}&radius=10&date=2015-05-19&per_page=49&format=json"
      req.params['app_id'] = ENV["BANDS_ID"]
    end
    events = JSON.parse(response.body)
    events.map do |event|
      event
    end
  end

end

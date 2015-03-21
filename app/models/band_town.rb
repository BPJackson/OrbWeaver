class BandTown

  require 'bandsintown'

  # def initialize
  #   @client = Bandsintown.app_id = 'orbweaver'
  #   @events = events = Bandsintown::Event.on_sale_soon({
  #     :location => "Boston, MA",
  #     :radius => 10
  #   })
  # end

  def initialize
     @conn = Faraday.new(:url => 'http://api.bandsintown.com') do |faraday|
     faraday.request  :url_encoded             # form-encode POST params
     faraday.response :logger                  # log requests to STDOUT
     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
     end
   end

   def event_sale
     response = @conn.get "/events/on_sale_soon.json", { app_id: 'ORBWEAVER' }
     JSON.parse(response.body)
   end
end

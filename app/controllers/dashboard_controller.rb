class DashboardController < ApplicationController

  def index
    if params[:search]
      @city = params[:search]
    #   @city = "Kansas City, MO"
      # @city = request.env["omniauth.params"]["search"]
    else
      @city = "Denver,CO"
    end


    if request.env['omniauth.auth']
      @city = request.env["omniauth.params"]["search"]
    end

      @bandtown = BandTown.new
      # creates list of bands in town artists that go on sale next week for denver, as an array
      @events_array = @bandtown.denver_events(@city).flatten.uniq

      @bands_on_sale_soon =  @events_array.map do |event|
                               event["artists"][0]["name"]
                             end

      @events_list = @bandtown.denver_events(@city).flatten.uniq

      #iterates through each band and returns an array of RSpotify artist objects. Each RSpotify artist is its own array.
      @artists_data = @bands_on_sale_soon.map do |artist|
      RSpotify::Artist.search("#{artist}", limit: 1, market: "US")
      end
      #deletes empty arrays in the larger array
      @artists_data = @artists_data.delete_if {|elem| elem.flatten.empty? }
      #all top tracks for all of the artists
      @all_top_tracks = @artists_data.map do |artist|
        artist[0].top_tracks(:US)
      end
      # creates Spotify playlist upon callback
      if request.env['omniauth.auth']
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      @playlist = @spotify_user.create_playlist!("Orbweaver-Playlist through #{14.days.from_now.strftime("%m/%d")}")
      @spotify_user.follow(@playlist)
      # binding.pry
        @all_top_tracks.each do |track|
          @playlist.add_tracks!(track, position: 0)
        end
      end

  end

end

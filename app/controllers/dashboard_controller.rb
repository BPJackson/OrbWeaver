class DashboardController < ApplicationController

  def index
    # creates Spotify playlist upon callback
    if request.env['omniauth.auth']
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @playlist = @spotify_user.create_playlist!('Orbweaver-Playlist')
    @spotify_user.follow(@playlist)
    end
    # creates list of bands in town artists that go on sale next week
    @bandtown = BandTown.new
    @bands_on_sale_soon = @bandtown.denver_event_sales.flatten.uniq

    # creates array of Spotify information based on the bands_on_sale_soon array
    @artists_data = @bands_on_sale_soon.map do |artist|
    RSpotify::Artist.search("#{artist}", limit: 1, market: "US")
    end
    # takes array of artists_data, maps through, and returns the top tracks for each artist
    # @artists_data[10][0].id (an example that is close to what I'm trying to return)
    @artists_inner_data = @artists_data[0]
    @artists_inner_data.map do |artist|
    end
  end

end

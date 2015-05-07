class DashboardController < ApplicationController

  def index
    @bandtown = BandTown.new
    # creates list of bands in town artists that go on sale next week for denver, as an array
    @bands_on_sale_soon = @bandtown.denver_event_sales.flatten.uniq

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
    #attempt to get into the @all_top_tracks array and return one array of raw tracks, rather than an array of arrays.
    # @all_top_tracks = @all_top_tracks.delete_if {|elem| elem.flatten.empty? }
    #
    # @tracks_to_add = @all_top_tracks.map do |track|
    #   track
    # end

    # @all = @tracks_to_add.map do |track|
    #   track
    # end

    # @all_artist_tracks = @artists_data.each do |artist|
    #   artist[0].each do |a|
    #     a.top_tracks(:US)
    #   end
    # end

    # binding.pry


    # takes array of artists_data, maps through, and returns the top tracks for each artist
    # @artists_data[10][0].id (an example that is close to what I'm trying to return)
    # @artists_inner_data = @artists_data[0]
    # @artists_inner_data.map do |artist|
    #   artist
    # end
    # # getting the top tracks for each artist in

    # creates Spotify playlist upon callback
    if request.env['omniauth.auth']
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @playlist = @spotify_user.create_playlist!('Orbweaver-Playlist')
    @spotify_user.follow(@playlist)
      @all_top_tracks.each do |track|
        @playlist.add_tracks!(track, position: 0)
      end
    # @playlist.add_tracks!(@all_top_tracks[0], position: 0)
      # end
    # @playlist.add_tracks!(@all_top_tracks.flatten, position: 0)
    end

   end
end

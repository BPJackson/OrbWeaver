class DashboardController < ApplicationController

  def index
    # this authenitcates app, should improve rate limits
    # checks the incomming params and sets the @city instance variable
    if params[:search]
      @city = params[:search]
    elsif request.env['omniauth.auth']
    # pulls the search param out of the omniauth return
      @city = request.env["omniauth.params"]["search"]
    else
      @city = "Denver,CO"
    end

    bandtown = BandTown.new
    # creates an array of Bandsintown events next week for @city
    @events_array = bandtown.usa_events(@city).flatten.uniq
    # creates an array of artist names, generated from the @events_array

    # checks for callback Omniauth hash
    if request.env['omniauth.auth']

      artist_list = @events_array.map do |event|
        event["artists"][0]["name"]
      end

      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])


      user_token = request.env['omniauth.auth']['credentials']['token']
      # iterates through each artist and returns an array of RSpotify artist objects. Each RSpotify artist is its own array.
      rspotify_artists_array = artist_list.map do |artist|
        SpotifySearch.new().artist_search(artist, user_token)
        # RSpotify::Artist.search("#{artist}", limit: 1, market: "US")
      end

      rspotify_artists_array.shift
      # rspotify_artists_array = rspotify_artists_array.delete_if {|elem| elem.flatten.empty? }
      # rspotify_artists_array.delete_if { |key| key["artist"]["items"] == []}
      rspotify_artists_array.delete_if {|x| x["artists"]["items"].empty? }

      artist_ids = rspotify_artists_array.map do |artist|
          artist["artists"]["items"][0]["id"]
      end

      all_top_tracks = artist_ids.map do |artist|
        SpotifySearch.new().artist_top_tracks(artist, user_token)
      end


      all_top_tracks.delete_if {|x| x["tracks"].empty? }

      uri_list = all_top_tracks.map do |track|
        track["tracks"][0]["album"]["uri"]
      end

      binding.pry

      playlist = SpotifySearch.new().create_spotify_playlist(@spotify_user.id, user_token)

      SpotifySearch.new().add_spotify_track(playlist["id"], @spotify_user.id, user_token, uri_list)


      # deletes empty arrays in the entire array
      # all top tracks for all of the RSpotify artists

      # all_top_tracks = track_ids.map do |track|
      #   SpotifySearch.new().
      # end

      #
      #
      # # deletes empty arrays
      # all_top_tracks.delete_if {|elem| elem.flatten.empty? }
      #
      # # adds tracks, one batch at a time, to the newly created Orbweaver playlist
      #
      # all_top_tracks.flatten!
      #
      # playlist.add_tracks!(all_top_tracks[0..99])
      # if all_top_tracks.length > 99
      # playlist.add_tracks!(all_top_tracks[100..199])
      # end
      # if all_top_tracks.length > 199
      #   playlist.add_tracks!(all_top_tracks[200..299])
      # end
    end

  end

end

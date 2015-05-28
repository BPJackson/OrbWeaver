class DashboardController < ApplicationController

  def index
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

    # checks for callback Omniauth hash
    if request.env['omniauth.auth']
      spotify_connection = SpotifyRequest.new
      # instantiates new RSpotify User
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      # converts @events_array to array of names
      artist_list = @events_array.map do |event|
        event["artists"][0]["name"]
      end
      # pulls token from hash, to pass as an argument
      user_token = request.env['omniauth.auth']['credentials']['token']
      # feeds artists names into a Spotify artist search, bridging the gap between the Bandsintown and Spotify API's
      spotify_artists_array = artist_list.each_with_index.map do |artist, i|
        # if i % 4 == 0
          sleep 0.5
        # end
        spotify_connection.artist_search(artist, user_token)
      end

      # pops off the first index in the spotify_artists_array, which is junk
      spotify_artists_array.shift
      # deletes hashes with ["items"] that have empties
      spotify_artists_array.delete_if {|x| x["artists"]["items"].empty? }
      # grabs artist ID's to feed to artist_top_tracks method
      artist_ids = spotify_artists_array.map do |artist|
        artist["artists"]["items"][0]["id"]
      end
      # creates a collection of top tracks data for all artists
      all_top_tracks = artist_ids.map do |artist|
        spotify_connection.artist_top_tracks(artist, user_token)
      end
      # deletes ["tracks"] with empty values
      all_top_tracks.delete_if {|x| x["tracks"].empty? }
      # creates collection of all URI's for the top tracks
      track_uris = all_top_tracks.map do |artist_track_group|
      	artist_track_group["tracks"].map do |track|
      		 track["uri"]
      	end
      end

      track_uris.flatten!
      # slices the array into selections of 89 or less, to accomodate the Spotify request limit
      split_arrays = track_uris.each_slice(89).to_a
      # generates a new playlist in @spotify_user's account
      playlist = spotify_connection.create_spotify_playlist(@spotify_user.id, user_token)
      # adds tracks to playlist

      split_arrays.each do |track_uri_group|
        spotify_connection.add_spotify_track(playlist["id"], @spotify_user.id, user_token, track_uri_group)
      end
    end

  end

end

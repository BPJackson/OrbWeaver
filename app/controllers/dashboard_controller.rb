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
    # creates an array of artist names, generated from the @events_array
    artist_list = @events_array.map do |event|
      event["artists"][0]["name"]
    end
    # this authenitcates app, should improve rate limits
    RSpotify.authenticate(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'])

    # iterates through each artist and returns an array of RSpotify artist objects. Each RSpotify artist is its own array.
    rspotify_artists_array = artist_list.map do |artist|
      RSpotify::Artist.search("#{artist}", limit: 1, market: "US")
    end
    # deletes empty arrays in the entire array
    rspotify_artists_array = rspotify_artists_array.delete_if {|elem| elem.flatten.empty? }
    # all top tracks for all of the RSpotify artists
      all_top_tracks = rspotify_artists_array.map do |artist|
      artist[0].top_tracks(:US)
    end

    # checks for callback Omniauth hash
    if request.env['omniauth.auth']
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      playlist = @spotify_user.create_playlist!("Orbweaver-Playlist through #{14.days.from_now.strftime("%m/%d")}")
      @spotify_user.follow(playlist)
      # deletes empty arrays
      all_top_tracks.delete_if {|elem| elem.flatten.empty? }

      # adds tracks, one batch at a time, to the newly created Orbweaver playlist

      all_top_tracks.flatten!

      playlist.add_tracks!(all_top_tracks[0..99])
      if all_top_tracks.length > 99
      playlist.add_tracks!(all_top_tracks[100..199])
      end
      if all_top_tracks.length > 199
        playlist.add_tracks!(all_top_tracks[200..299])
      end
    end

  end

end

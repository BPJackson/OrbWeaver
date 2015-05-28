class SpotifyRequest
  def initialize
    @conn = Faraday.new(:url => 'https://api.spotify.com/v1/') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def artist_search(artist, token)
    response = @conn.get do |req|
      req.url "search?q=#{artist}&limit=1&type=artist"
      req.headers['Authorization'] = "Bearer #{token}"
    end
    if response.status.to_s.start_with?('20')
      return JSON.parse(response.body)
    end
    sleep 1
    {"artists"=>
  {"href"=>"#",
   "items"=>[],
   "limit"=>1,
   "next"=>nil,
   "offset"=>0,
   "previous"=>nil,
   "total"=>0}}
  end

  def artist_top_tracks(artist_id, token)
    response = @conn.get do |req|
      req.url "artists/#{artist_id}/top-tracks"
      req.params['country'] = "US"
      req.headers['Authorization'] = "Bearer #{token}"
    end
    JSON.parse(response.body)
  end

  def create_spotify_playlist(user_id, token)
    response = @conn.post do |req|
      req.url "users/#{user_id}/playlists"
      req.headers['Authorization'] = "Bearer #{token}"
      req.body = '{ "name": "Orbweaver-Playlist", "public": true }'
    end
    JSON.parse(response.body)
  end

  def add_spotify_track(playlist_id, user_id, token, uris)
    string = uris.join(',')
    response = @conn.post do |req|
      req.url "users/#{user_id}/playlists/#{playlist_id}/tracks"
      req.headers['Authorization'] = "Bearer #{token}"
      req.params['uris'] = "#{string}"
    end
  end

end

class DashboardController < ApplicationController

  def index
    if request.env['omniauth.auth']
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @playlist = RSpotify::Playlist.find('121425006', '7HRUw3xDnKhKt4KFR3K2lH')
    @artists = @playlist.tracks.map(&:artists)
    @spotify_user.follow(@playlist)
    end
  end

  # def other
  #   @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
  #   @playlist = RSpotify::Playlist.find('121425006', '7HRUw3xDnKhKt4KFR3K2lH')
  #   @artists = @playlist.tracks.map(&:artists)
  #   @spotify_user.follow(@playlist)
  # end


end

class SessionsController < ApplicationController

  def new
  end

  def create
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    session[:user_id] = spotify_user.to_hash

    puts  spotify_user.methods

      puts session[:user_id]
    #  user = User.find_or_create_by(oauth_id: token)
    # user.update_attributes(name: env['omniauth.auth']['info']['name'],
                          #  email: env['omniauth.auth']['info']['email'])
    # spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # hash = spotify_user.to_hash
    # redirect_to dashboard_path

    # code below for old, non-OmniAuth authentication
    #
    # user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    #   log_in user
    #   params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    #   redirect_to user
    # else
    #     flash.now[:danger] = "Invalid email/password combination"
    #     render 'new'
    # end
    redirect_to dashboard_path
  end

  def destroy
    # code below for old, non-OmniAuth authentication
    #
    # log_out if logged_in?
    # redirect_to root_url
  end

end

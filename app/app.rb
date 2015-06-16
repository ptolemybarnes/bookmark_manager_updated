require 'sinatra'
require 'sinatra/flash'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash
  use Rack::MethodOverride

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url],
                title: params[:title])
    tag = Tag.create(text: params[:tags])
    link.tags << tag
    link.save
    redirect to('/links')
  end

  get '/tags/:text' do
    tag = Tag.first(text: params[:text])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/users/password_reset/:password_token' do
    if user = User.first(password_token: params[:password_token])
      session[:password_token] = params[:password_token]
      erb :'password/new'
    else
      redirect to '/links'
    end
  end
  
  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    flash[:notice] = 'Goodbye!'
    session[:user_id] = nil
    redirect to('/links')
  end

  get '/password_reset' do
    erb :password_reset
  end

  post '/password_reset' do
    user = User.first(email: params[:email])
    user.password_token = (1..64).map { ('A'..'Z').to_a.sample }.join
    user.save
    redirect to '/sessions/new'
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

end

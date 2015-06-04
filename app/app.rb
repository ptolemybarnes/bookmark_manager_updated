require 'sinatra'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'

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
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation])
    session[:user_id] = user.id
    redirect to('/links')
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

end

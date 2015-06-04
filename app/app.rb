require 'sinatra'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base

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

end

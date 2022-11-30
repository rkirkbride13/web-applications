# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    @album = repo.find(params[:id])
    repo = ArtistRepository.new
    @artist = repo.find(@album.artist_id)
    return erb(:album)
  end

  post '/albums' do
    invalid_album_parameters?
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]
    repo.create(new_album)
    @album = params[:title]
    return erb(:album_created)
  end

  def invalid_album_parameters?
    if params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
      status 400
      return ''
    end
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    return erb(:artist)
  end

  post '/artists' do
    invalid_artist_parameters?
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    repo.create(new_artist)
    @artist = params[:name]
    return erb(:artist_created)
  end

  def invalid_artist_parameters?
    if params[:name] == nil || params[:genre] == nil
      status 400
      return ''
    end
  end

  get '/' do
    @password = params[:password]
    return erb(:password)
  end
end
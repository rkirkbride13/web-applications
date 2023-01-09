require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/helloHTML' do
    return erb(:helloHTML)
  end

  get '/helloERB' do
    @name = params[:name]
    return erb(:helloERB)
  end

  get '/names' do
    name = params[:name]
  
    return "#{name}"
  end

  post '/sort-names' do
    names = params[:names]
    sorted_names = names.split(",").sort
    return sorted_names.join(",")
  end

end
require 'sinatra/base'

class Application < Sinatra::Base # Application class inherits from Sinatra::Base

  # GET /
  # Root path (homepage, index page)
  get '/' do
    return 'Hello!'
  end

  get '/posts' do
    name = params[:name]
    cohort_name = params[:cohort_name]

    return "Hello #{name}, you are in the chort #{cohort_name}"
  end

  post '/posts' do
    title = params[:title]
    return "Post was created with title: #{title}"
  end

end
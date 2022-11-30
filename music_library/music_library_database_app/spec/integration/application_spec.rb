require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    it 'returns 200 OK and list of albums as HTML page with links' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('
      Title: <a href="/albums/2"> Surfer Rosa </a>
      Released: 1988')
      expect(response.body).to include('
      Title: <a href="/albums/3"> Waterloo </a>
      Released: 1974')
      expect(response.body).to include('
      Title: <a href="/albums/9"> Baltimore </a>
      Released: 1978')
    end
  end

  context "POST /albums" do
    it 'returns 200 OK and creates an album' do
      response = post(
        '/albums',
        title: 'Voyager',
        release_year: '2022',
        artist_id: '2')
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyager')
    end
  end

  context "GET /artists" do
    it "returns status 200 OK and the list of artists as HTML page with links" do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('
      Name: <a href="/artists/2"> ABBA </a>')
      expect(response.body).to include('
      Name: <a href="/artists/3"> Taylor Swift </a>')
      expect(response.body).to include('
      Name: <a href="/artists/4"> Nina Simone </a>')
    end
  end

  context "POST /albums" do
    it "returns status 200 OK and creates an artist. List artists to check creation" do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq 200
      expect(response.body).to eq ''
      
      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end
  end

  context "GET /albums/:id" do
    it "returns a single album with id 2" do
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1> Surfer Rosa </h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end

    it "returns a single album with id 3" do
      response = get('/albums/3')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1> Waterloo </h1>')
      expect(response.body).to include('Release year: 1974')
      expect(response.body).to include('Artist: ABBA')
    end
  end

  context "GET /artists/:id" do
    it "returns a single artist with id 1" do
      response = get('/artists/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1> Pixies </h1>')
      expect(response.body).to include('Genre: Rock')
    end

    it "returns a single artist with id 3" do
      response = get('/artists/3')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1> Taylor Swift </h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end

  context "GET /" do
    it "returns a Hello page if the password is correct" do
      response = get('/', password: 'Password1')
      expect(response.body).to include ('Hello!')
    end

    it "returns a Access Forbidden page if the password is incorrect" do
      response = get('/', password: 'wrong')
      expect(response.body).to include ('Access forbidden!')
    end
  end
end

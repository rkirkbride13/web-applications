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

  context "GET /albums/new" do
    it "returns the form page" do
      response = get('/albums/new')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Add an album</h1>')
      expect(response.body).to include('<form action="/albums" method="POST">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="submit" value="Submit" />')
    end
  end

  context "POST /albums" do
    it "should validate album parameters" do
      response = post('/albums', invalid_album_title: 'OK Computer', another_invalid_thing: 123)
      expect(response.status).to eq 400
    end

    it 'returns 200 OK, creates an album and returns confirmation page' do
      response = post(
        '/albums',
        title: 'Voyager',
        release_year: '2022',
        artist_id: '2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Voyager added!</h1>')

      response = get('/albums')
      expect(response.body).to include('Voyager')
    end

    it 'returns 200 OK, creates a different album and returns confirmation page' do
      response = post(
        '/albums',
        title: 'Midnights',
        release_year: '2022',
        artist_id: '3')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Midnights added!</h1>')

      response = get('/albums')
      expect(response.body).to include('Midnights')
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

  context "GET /artists/new" do
    it "returns the form page" do
      response = get('/artists/new')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Add an artist</h1>')
      expect(response.body).to include('<form action="/artists" method="POST">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
      expect(response.body).to include('<input type="submit" value="Submit" />')
    end
  end

  context "POST /artists" do
    it "should validate artist parameters" do
      response = post('/artists', invalid_artist_title: 'OK Computer', another_invalid_thing: 123)
      expect(response.status).to eq 400
    end

    it "returns status 200 OK and creates an artist. List artists to check creation" do
      response = post('/artists', name: 'Caroline Polacheck', genre: 'Electronic')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Caroline Polacheck added!</h1>')
      
      response = get('/artists')
      expect(response.body).to include('Caroline Polacheck')
    end

    it "returns status 200 OK and creates another artist. List artists to check creation" do
      response = post('/artists', name: 'Gorillaz', genre: 'Indie')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Gorillaz added!</h1>')
      
      response = get('/artists')
      expect(response.body).to include('Gorillaz')
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

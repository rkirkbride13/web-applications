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
    it 'returns 200 OK and list of albums as HTML page' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('
      Title: Surfer Rosa
      Released: 1988')
      expect(response.body).to include('
      Title: Waterloo
      Released: 1974')
      expect(response.body).to include('
      Title: Baltimore
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
    it "returns status 200 OK and the list of artists" do
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /albums" do
    it "returns status 200 OK and creates an artist. List artists to check creation" do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq 200
      expect(response.body).to eq ''
      
      response = get('/artists')
      expect(response.body).to eq 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Wild nothing'
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

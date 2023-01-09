require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /helloHTML" do
    it "returns hello and status 200 OK" do
      response = get('/helloHTML')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Hello!</h1>")
      expect(response.body).to include('<img src="hello.jpg" />')
    end
  end

  context "GET /helloERB" do
    it "returns hello with a given name and status 200 OK" do
      response = get('/helloERB', name: "Robbie")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Hello Robbie!</h1>")
      expect(response.body).to include('<img src="hello.jpg" />')
    end

    it "returns hello with a differenet name and status 200 OK" do
      response = get('/helloERB', name: "Ella")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Hello Ella!</h1>")
      expect(response.body).to include('<img src="hello.jpg" />')
    end
  
  end
  
  context "GET /names to pass with the correct names" do
    it "returns 200 OK with the right content" do
      response = get("/names?name=Julia, Mary, Karim")
      expect(response.status).to eq(200)
      expect(response.body).to eq("Julia, Mary, Karim")
    end
  end

  context "POST /sort-names to pass with list of names" do
    it "returns 200 OK with the sorted list" do
      response = post('/sort-names?names=Joe,Alice,Zoe,Julia,Kieran')
      expect(response.status).to eq(200)
      expect(response.body).to eq 'Alice,Joe,Julia,Kieran,Zoe'
    end
  end
end
require "./spec_helper"

describe Raleigh::App do
  it "responds correctly to requests made to '/' path " do
    response = spec_client.exec HTTP::Request.new "GET", "/"

    response.status_code.should eq 200
    response.content_type.should eq "text/html"
  end

  it "renders a correct response for '/' path" do
    response = spec_client.exec HTTP::Request.new "GET", "/"
    response.body.should contain "<title>raleigh</title>"
  end

  it "serves CSS assets with the StaticFileHandler" do
    response = spec_client.exec HTTP::Request.new "GET", "/build/index.css"
    response.status_code.should eq 200
    response.content_type.should eq "text/css"
    response.body.should be_truthy
  end

  it "serves JS assets with the StaticFileHandler" do
    want = ["application/javascript", "text/javascript"]
    response = spec_client.exec HTTP::Request.new "GET", "/build/index.js"
    response.status_code.should eq 200
    want.should contain response.content_type
    response.body.should be_truthy
  end

  it "serves favicon assets with the StaticFileHandler" do
    response = spec_client.exec HTTP::Request.new "GET", "/favicon.ico"
    response.status_code.should eq 200
    response.body.should be_truthy
  end

  it "denies access to directory listing of static assets" do
    response = spec_client.exec HTTP::Request.new "GET", "/build/"
    response.status_code.should eq 404
  end

  it "renders the appropriate response for 404 errors" do
    response = spec_client.exec HTTP::Request.new "GET", "/does-not-exist"
    response.status_code.should eq 404
    response.content_type.should eq "text/plain"
    response.body.should contain "No such route as /does-not-exist"
  end

  it "renders the appropriate response for 405 errors" do
    response = spec_client.exec HTTP::Request.new "POST", "/"
    response.status_code.should eq 405
    response.body.should contain "405 Method Not Allowed"
  end
end

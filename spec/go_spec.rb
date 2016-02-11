require 'spec_helper'

require "json"
require "open-uri"
require "openssl"

describe "TLSv1.2 HIGH cipher support" do

  it "is supported" do
    expect {
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers] = "TLSv1.2+HIGH:!aNULL:!eNULL"
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = "TLSv1_2"
      @json = URI.parse("https://www.howsmyssl.com/a/check").read
    }.to_not raise_error
    rating = JSON.parse(@json)["rating"]
    expect(["Probably Okay", "Improvable"]).to include rating
    if rating == "Improvable"
      $stderr.puts "WARNING: SSL rating is: Improvable"
    end
  end

end

require 'spec_helper'

require "json"
require "open-uri"
require "openssl"

describe "TLSv1.2 HIGH cipher support" do

  it "is supported" do
    expect {
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_NO_COMPRESSION
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers] = "TLSv1.2:!aNULL:!eNULL"
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = "TLSv1_2"
      @json = URI.parse("https://www.howsmyssl.com/a/check").read
    }.to_not raise_error
    rating = JSON.parse(@json)["rating"]
    expect(rating).to eql "Probably Okay"
  end

end

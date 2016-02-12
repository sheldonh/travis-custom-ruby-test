require 'spec_helper'

require "json"
require "open-uri"
require "openssl"
require "yaml"

describe "TLSv1.2 HIGH cipher support" do

  it "is supported" do
    expect {
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers] = "TLSv1.2+HIGH:!aNULL:!eNULL"
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = "TLSv1_2"
      @json = URI.parse("https://www.howsmyssl.com/a/check").read
    }.to_not raise_error
    report = JSON.parse(@json)
    rating = report["rating"]
    if rating == "Improvable"
      pending "could be improved:\n" + report.to_yaml.gsub(/^/, "\t")
    end
    expect(rating).to eql "Probably Okay"
  end

end

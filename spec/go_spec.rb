require 'spec_helper'

describe "TLSv1.2" do

  it "is supported" do
    expect {
      require "openssl"
      OpenSSL::SSL::SSLContext.new.ssl_version = :TLSv1_2
    }.to_not raise_error
  end

end

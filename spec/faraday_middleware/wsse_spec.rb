require 'spec_helper'

describe FaradayMiddleware::WSSE do

  let(:app) { double('app') }
  let(:wsse_key) { 'sample' }
  let(:wsse_secret) { 'sample' }

  let(:instance) { described_class.new(app, wsse_key, wsse_secret) }

  before do
    allow(Time).to receive_message_chain(:now,:utc,:iso8601).and_return("2015-11-27T13:37:00Z")
    allow(instance).to receive(:create_nonce).and_return('super_random')
  end

  describe '#wsse_token' do
    subject { instance.wsse_token }

    it { is_expected.to match /Username="sample"/ }
    it { is_expected.to eq 'UsernameToken Username="sample", PasswordDigest="M2ZiZGRmYTE3NWQ4NjYxZTQ1OGIzZjQzOWNiYzIzMzZlM2MxNDVjOA==", Nonce="super_random", Created="2015-11-27T13:37:00Z"' }

  end

end

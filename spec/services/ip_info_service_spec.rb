# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IpInfoService do
  let(:ip_address) { '167.160.32.235' }
  let(:token) { ENV.fetch('IP_INFO_TOKEN') }

  subject { described_class.fetch_ip_info(ip_address) }

  describe '#fetch_ip_info', :vcr do
    context 'when the request is successful' do
      it 'returns the parsed JSON response' do
        expect(subject).to include('city', 'country', 'ip', 'loc', 'org', 'postal', 'region', 'timezone')
      end
    end

    context 'when the request fails' do
      before do
        stub_request(:get, "https://ipinfo.io/#{ip_address}?token=#{token}").to_return(status: 500)
      end

      it 'raises an error' do
        expect { subject }.to raise_error(IpInfoService::IpInfoError, 'Failed to fetch IP info: 500')
      end
    end
  end
end

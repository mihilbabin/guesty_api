# frozen_string_literal: true

RSpec.describe GuestyAPI::Accounts do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:accounts) { described_class.new(client) }

  describe '#retrieve' do
    subject { accounts.retrieve }

    let(:url) { "#{api_root}/accounts/me" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('accounts/retrieve.json').read }
      let(:id) { '596f6fe706112710005d96ff' }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns account' do
        expect(subject).to be_a GuestyAPI::Entities::Account
      end

      it 'returns correct account' do
        expect(subject._id).to eq id
      end
    end
  end
end

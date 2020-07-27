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

    context 'with bad request' do
      before do
        stub_request(:get, "#{api_root}/accounts/me")
          .to_return(body: 'Bad Request', status: 400)
      end

      it 'throws API error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Bad Request', code: 400)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('accounts/retrieve.json').read }
      let(:id) { '596f6fe706112710005d96ff' }

      before do
        stub_request(:get, "#{api_root}/accounts/me")
          .to_return(body: body)
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

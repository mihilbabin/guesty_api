# frozen_string_literal: true

RSpec.describe GuestyAPI::Client do
  let(:client) do
    described_class.new(
      username: 'username',
      password: 'password',
      auth_mode: mode,
    )
  end

  %i[basic bearer].each do |auth_mode|
    context "with #{auth_mode} authentication" do
      let(:mode) { auth_mode }
      let(:data) { { name: 'body' } }
      let(:auth_hash) do
        if auth_mode == :basic
          { basic_auth: { username: 'username', password: 'password' } }
        else
          { headers: { 'Authorization' => 'Bearer username' } }
        end
      end

      describe '#get' do
        subject { client.get url: 'test', data: data }

        let(:data) { { q: 'query' } }

        it 'calls API' do
          expect(described_class).to receive(:get).with(
            'test', query: data, **auth_hash
          )
          subject
        end
      end

      describe '#post' do
        subject { client.post url: 'test', data: data }

        it 'calls API' do
          expect(described_class).to receive(:post).with(
            'test', body: data.to_json, **auth_hash
          )
          subject
        end
      end

      describe '#put' do
        subject { client.put url: 'test', data: data }

        it 'calls API' do
          expect(described_class).to receive(:put).with(
            'test', body: data.to_json, **auth_hash
          )
          subject
        end
      end

      describe '#delete' do
        subject { client.delete url: 'test' }

        it 'calls API' do
          expect(described_class).to receive(:delete).with(
            'test', **auth_hash
          )
          subject
        end
      end
    end
  end
end

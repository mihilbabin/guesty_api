# frozen_string_literal: true

RSpec.describe GuestyAPI::Webhooks do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:webhooks) { described_class.new(client) }

  describe '#list' do
    subject { webhooks.list }

    let(:url) { "#{api_root}/webhooks" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('webhooks/list.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns list of webhooks' do
        expect(subject).to all(be_a GuestyAPI::Entities::Webhook)
      end
    end
  end

  describe '#retrieve' do
    subject { webhooks.retrieve(id: id) }

    let(:id) { '595a7fc636f2491000b6b81a' }
    let(:url) { "#{api_root}/webhooks/#{id}" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:get, url).to_return(body: 'Not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('webhooks/retrieve.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns webhook' do
        expect(subject).to be_a GuestyAPI::Entities::Webhook
      end

      it 'returns correct webhook' do
        expect(subject._id).to eq id
      end
    end
  end

  describe '#create' do
    subject { webhooks.create(params: params) }

    let(:url) { "#{api_root}/webhooks" }
    let(:http_method) { :post }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      describe 'invalid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(body: body, status: 500)
        end

        let(:params) { {} }
        let(:body) { 'Path `url` is required.' }

        it 'raises error' do
          expect { subject }.to raise_error(
            an_instance_of(GuestyAPI::APIError)
              .and(having_attributes(message: body, code: 500)),
          )
        end
      end

      describe 'valid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(
              body: body,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:body) { fixture_file('webhooks/retrieve.json').read }
        let(:params) do
          {
            url: 'https://www.hookurl.com',
          }
        end

        it 'returns webhook' do
          expect(subject).to be_a GuestyAPI::Entities::Webhook
        end

        it 'returns fields' do
          expect(subject.url).to eq params[:url]
        end
      end
    end
  end

  describe '#update' do
    subject { webhooks.update(id: id, params: params) }

    let(:id) { '5901fa614258fd10000b78e3' }
    let(:url) { "#{api_root}/webhooks/#{id}" }
    let(:http_method) { :put }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:put, url).to_return(body: '', status: 204) }

      let(:params) { {} }

      # for some reasons update is always successful for non-existing hooks
      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'with valid request' do
      describe 'invalid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(status: 204)
        end

        let(:params) { { url: nil } }

        # `url` is required for creation but can be updated to nil (WTF?)
        it 'returns true' do
          expect(subject).to be true
        end
      end

      describe 'valid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(
              body: '',
              headers: { 'Content-Type' => 'application/json' },
              status: 204,
            )
        end

        let(:params) do
          {
            url: 'https://www.hookurl.com/new',
          }
        end

        it 'returns true' do
          expect(subject).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject { webhooks.delete(id: id) }

    let(:id) { '5901fa614258fd10000b78e3' }
    let(:url) { "#{api_root}/webhooks/#{id}" }

    context 'with bad request' do
      let(:http_method) { :delete }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:delete, url).to_return(status: 204) }

      # Every id returns 204 status
      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'with valid request' do
      before { stub_request(:delete, url).to_return(body: '', status: 204) }

      it 'returns true' do
        expect(subject).to be true
      end
    end
  end
end

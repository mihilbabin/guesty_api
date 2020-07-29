# frozen_string_literal: true

RSpec.describe GuestyAPI::Listings do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:listings) { described_class.new(client) }

  describe '#list' do
    subject { listings.list }

    let(:url) { "#{api_root}/listings" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('listings/list.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns list of listings' do
        expect(subject).to all(be_a GuestyAPI::Entities::Listing)
      end
    end
  end

  describe '#retrieve' do
    subject { listings.retrieve(id: id) }

    let(:id) { '59ac245d27cb310f0017afe3' }
    let(:url) { "#{api_root}/listings/#{id}?fields=" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:get, url).to_return(body: 'Listing not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Listing not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('listings/retrieve.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns listing' do
        expect(subject).to be_a GuestyAPI::Entities::Listing
      end

      it 'returns correct listing' do
        expect(subject._id).to eq id
      end
    end
  end

  describe '#create' do
    subject { listings.create(params: params) }

    let(:url) { "#{api_root}/listings" }
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
            .to_return(
              body: body.to_json,
              status: 400,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) { { nickname: nil } }
        let(:body) { { message: 'Please add a unique nickname' } }

        it 'raises error' do
          expect { subject }.to raise_error(
            an_instance_of(GuestyAPI::APIError)
              .and(having_attributes(message: body[:message], code: 400)),
          )
        end
      end

      describe 'valid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
        end

        let(:body) { fixture_file('listings/create.json').read }
        let(:params) do
          {
            address: {
              full: 'Eliezer Kaplan St 2, Tel Aviv-Yafo, Israel',
            },
            title: 'example listing',
            nickname: 'test',
          }
        end

        it 'returns user' do
          expect(subject).to be_a GuestyAPI::Entities::Listing
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'returns fields' do
          expect(subject.title).to eq params[:title]
          expect(subject.address['full']).to eq params.dig(:address, :full)
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end

  describe '#update' do
    subject { listings.update(id: id, params: params) }

    let(:id) { '59ac245d27cb310f0017afe3' }
    let(:url) { "#{api_root}/listings/#{id}" }
    let(:http_method) { :put }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before do
        stub_request(http_method, url)
          .to_return(body: 'Please, provide an valid listing id', status: 500)
      end

      let(:params) { {} }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Please, provide an valid listing id', code: 500)),
        )
      end
    end

    context 'with valid request' do
      describe 'invalid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(
              body: body.to_json,
              status: 400,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) { { nickname: nil } }
        let(:body) { { message: 'Please add a non-empty unique nickname' } }

        it 'raises error' do
          expect { subject }.to raise_error(
            an_instance_of(GuestyAPI::APIError)
              .and(having_attributes(message: body[:message], code: 400)),
          )
        end
      end

      describe 'valid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(
              body: { title: 'Test', _id: id }.to_json,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) do
          {
            title: 'Test',
          }
        end

        it 'returns user' do
          expect(subject).to be_a GuestyAPI::Entities::Listing
        end

        it 'returns fields' do
          expect(subject.title).to eq 'Test'
        end
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe GuestyAPI::Guests do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:guests) { described_class.new(client) }

  describe '#list' do
    subject { guests.list }

    let(:url) { "#{api_root}/guests" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('guests/list.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns list of guests' do
        expect(subject).to all(be_a GuestyAPI::Entities::Guest)
      end
    end
  end

  describe '#retrieve' do
    subject { guests.retrieve(id: id) }

    let(:id) { '5803ca18e48f450300c76173' }
    let(:url) { "#{api_root}/guests/#{id}?fields=" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:get, url).to_return(body: 'Guest not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Guest not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('guests/retrieve.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns user' do
        expect(subject).to be_a GuestyAPI::Entities::Guest
      end

      it 'returns correct guest' do
        expect(subject._id).to eq id
      end
    end
  end

  describe '#create' do
    subject { guests.create(params: params) }

    let(:url) { "#{api_root}/guests" }
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
            .to_return(body: body, status: 400)
        end

        let(:params) { {} }
        let(:body) { 'Email is required' }

        it 'raises error' do
          expect { subject }.to raise_error(
            an_instance_of(GuestyAPI::APIError)
              .and(having_attributes(message: body, code: 400)),
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

        let(:body) { fixture_file('guests/create.json').read }
        let(:params) do
          {
            firstName: 'John',
            lastName: 'Doe',
          }
        end

        it 'returns guest' do
          expect(subject).to be_a GuestyAPI::Entities::Guest
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'returns fields' do
          expect(subject.firstName).to eq params[:firstName]
          expect(subject.lastName).to eq params[:lastName]
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end

  describe '#update' do
    subject { guests.update(id: id, params: params) }

    let(:id) { '5901fa614258fd10000b78e3' }
    let(:url) { "#{api_root}/guests/#{id}" }
    let(:http_method) { :put }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:put, url).to_return(body: 'Guest not found', status: 404) }

      let(:params) { {} }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Guest not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      describe 'valid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(
              body: { firstName: 'Jane', _id: id }.to_json,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) do
          {
            firstName: 'Jane',
          }
        end

        it 'returns guest' do
          expect(subject).to be_a GuestyAPI::Entities::Guest
        end

        it 'returns fields' do
          expect(subject.firstName).to eq 'Jane'
        end
      end
    end
  end

  describe '#delete' do
    subject { guests.delete(id: id) }

    let(:id) { '5f2672f9c18d86002ce30300' }
    let(:url) { "#{api_root}/guests/#{id}" }

    context 'with bad request' do
      let(:http_method) { :delete }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:delete, url).to_return(body: 'Guest not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Guest not found', code: 404)),
        )
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

# frozen_string_literal: true

RSpec.describe GuestyAPI::Users do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:users) { described_class.new(client) }

  describe '#list' do
    subject { users.list }

    let(:url) { "#{api_root}/users?fields=&limit=20&q=&skip=0" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('users/list.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns list of users' do
        expect(subject).to all(be_a GuestyAPI::Entities::User)
      end
    end
  end

  describe '#retrieve' do
    subject { users.retrieve(id: id) }

    let(:id) { '5901fa614258fd10000b78e3' }
    let(:url) { "#{api_root}/users/#{id}?fields=" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:get, url).to_return(body: 'User not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'User not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('users/retrieve.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns user' do
        expect(subject).to be_a GuestyAPI::Entities::User
      end

      it 'returns correct user' do
        expect(subject._id).to eq id
      end
    end
  end

  describe '#create' do
    subject { users.create(params: params) }

    let(:url) { "#{api_root}/users" }
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

        let(:body) { fixture_file('users/create.json').read }
        let(:params) do
          {
            fullName: 'Uria Goldy',
            email: 'urigold@guesty.com',
            emails: ['urigold@guesty.com'],
            password: 'password',
          }
        end

        it 'returns user' do
          expect(subject).to be_a GuestyAPI::Entities::User
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'returns fields' do
          expect(subject.fullName).to eq params[:fullName]
          expect(subject.email).to eq params[:email]
          expect(subject.emails).to eq params[:emails]
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end

  describe '#update' do
    subject { users.update(id: id, params: params) }

    let(:id) { '5901fa614258fd10000b78e3' }
    let(:url) { "#{api_root}/users/#{id}" }
    let(:http_method) { :put }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:put, url).to_return(body: 'User not found', status: 404) }

      let(:params) { {} }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'User not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      describe 'invalid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(body: body, status: 500)
        end

        let(:params) { { email: nil } }
        let(:body) { 'User validation failed: email: Path `email` is required.' }

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
              body: { fullName: 'John Doe', _id: id }.to_json,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) do
          {
            fullName: 'John Doe',
          }
        end

        it 'returns user' do
          expect(subject).to be_a GuestyAPI::Entities::User
        end

        it 'returns fields' do
          expect(subject.fullName).to eq 'John Doe'
        end
      end
    end
  end

  describe '#delete' do
    subject { users.delete(id: id) }

    let(:id) { '5901fa614258fd10000b78e3' }
    let(:url) { "#{api_root}/users/#{id}" }

    context 'with bad request' do
      let(:http_method) { :delete }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:delete, url).to_return(body: 'User not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'User not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      before { stub_request(:delete, url).to_return(body: '', status: 204) }

      it 'returns user' do
        expect(subject).to be true
      end
    end
  end
end

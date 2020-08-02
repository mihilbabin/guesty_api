# frozen_string_literal: true

RSpec.describe GuestyAPI::Reservations do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:reservations) { described_class.new(client) }

  describe '#list' do
    subject { reservations.list }

    let(:url) { "#{api_root}/reservations" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('reservations/list.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns list of reservations' do
        expect(subject).to all(be_a GuestyAPI::Entities::Reservation)
      end
    end
  end

  describe '#retrieve' do
    subject { reservations.retrieve(id: id) }

    let(:id) { '595fe29f4ab86112341425ac' }
    let(:url) { "#{api_root}/reservations/#{id}?fields=" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:get, url).to_return(body: 'Reservation not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Reservation not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('reservations/retrieve.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns reservation' do
        expect(subject).to be_a GuestyAPI::Entities::Reservation
      end

      it 'returns correct reservation' do
        expect(subject._id).to eq id
      end
    end
  end

  describe '#create' do
    subject { reservations.create(params: params) }

    let(:url) { "#{api_root}/reservations" }
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
              status: 500,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) { {} }
        let(:body) { { message: 'Listing ID is required' } }

        it 'raises error' do
          expect { subject }.to raise_error(
            an_instance_of(GuestyAPI::APIError)
              .and(having_attributes(message: body[:message], code: 500)),
          )
        end
      end

      describe 'valid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(body: body, headers: { 'Content-Type' => 'application/json' })
        end

        let(:body) { fixture_file('reservations/create.json').read }
        let(:params) do
          {
            listingId: '59b928bb8e6bb31000219e58',
            checkInDateLocalized: '2017-09-15',
            checkOutDateLocalized: '2017-09-18',
            status: 'inquiry',
            money: { fareAccommodation: '500', currency: 'USD' },
            guest: {
              firstName: 'Tony',
              lastName: 'Stark',
              phone: '+7777777',
              email: 'tony@stark.com',
            },
          }
        end

        it 'returns reservation' do
          expect(subject).to be_a GuestyAPI::Entities::Reservation
        end

        it 'returns fields' do
          expect(subject.listingId).to eq params[:listingId]
        end
      end
    end
  end

  describe '#update' do
    subject { reservations.update(id: id, params: params) }

    let(:id) { '595fe29f4ab86112341425ac' }
    let(:url) { "#{api_root}/reservations/#{id}" }
    let(:http_method) { :put }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before do
        stub_request(http_method, url)
          .to_return(body: 'Reservation not found', status: 404)
      end

      let(:params) { {} }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Reservation not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      describe 'invalid params' do
        before do
          stub_request(http_method, url)
            .with(body: params)
            .to_return(
              body: body,
              status: 500,
            )
        end

        let(:params) { { listingId: nil } }
        let(:body) { 'Listing not found' }

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
              body: { checkOutDateLocalized: '2020-10-10', _id: id }.to_json,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:params) do
          {
            checkOutDateLocalized: '2020-10-10',
          }
        end

        it 'returns user' do
          expect(subject).to be_a GuestyAPI::Entities::Reservation
        end

        it 'returns fields' do
          expect(subject.checkOutDateLocalized).to eq '2020-10-10'
        end
      end
    end
  end
end

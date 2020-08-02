# frozen_string_literal: true

RSpec.describe GuestyAPI::GuestInbox do
  let(:client) do
    GuestyAPI::Client.new(
      username: 'username',
      password: 'password',
      auth_mode: :basic,
    )
  end
  let(:guest_inbox) { described_class.new(client) }

  describe '#list' do
    subject { guest_inbox.list }

    let(:url) { "#{api_root}/inbox/conversations" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with valid request' do
      let(:body) { fixture_file('guest_inbox/list.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns list of guest conversations' do
        expect(subject).to all(be_a GuestyAPI::Entities::GuestConversation)
      end
    end
  end

  describe '#retrieve' do
    subject { guest_inbox.retrieve(id: id) }

    let(:id) { '59229452b4380d1000d52090' }
    let(:url) { "#{api_root}/inbox/conversations/#{id}?fields=" }

    context 'with bad request' do
      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before { stub_request(:get, url).to_return(body: 'Conversation not found', status: 404) }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Conversation not found', code: 404)),
        )
      end
    end

    context 'with valid request' do
      let(:body) { fixture_file('guest_inbox/retrieve.json').read }

      before do
        stub_request(:get, url).to_return(
          body: body,
          headers: { 'Content-Type' => 'application/json' },
        )
      end

      it 'returns guest conversation' do
        expect(subject).to be_a GuestyAPI::Entities::GuestConversation
      end

      it 'returns correct conversation' do
        expect(subject._id).to eq id
      end
    end
  end

  describe '#post' do
    subject { guest_inbox.post(id: id, params: params) }

    let(:url) { "#{api_root}/inbox/conversations" }
    let(:http_method) { :post }
    let(:id) { '5919be619e2b4210006f5ef7' }

    context 'with bad request' do
      let(:params) { {} }

      it_behaves_like 'bad request'
    end

    context 'with bad id' do
      before do
        stub_request(http_method, url)
          .with(body: params)
          .to_return(body: 'Forbidden', status: 403)
      end

      let(:params) { {} }

      it 'raises error' do
        expect { subject }.to raise_error(
          an_instance_of(GuestyAPI::APIError)
            .and(having_attributes(message: 'Forbidden', code: 403)),
        )
      end
    end

    context 'with valid request' do
      describe 'invalid params' do
        before do
          stub_request(http_method, url)
            .with(body: params.merge(conversationId: id))
            .to_return(body: body, status: 400)
        end

        let(:params) do
          {
            sms: { body: 'HEY!' },
          }
        end
        let(:body) { 'Module is required' }

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
            .with(body: params.merge(conversationId: id))
            .to_return(
              body: body,
              headers: { 'Content-Type' => 'application/json' },
            )
        end

        let(:body) { fixture_file('guest_inbox/post.json').read }
        let(:params) do
          {
            module: 'sms',
            sms: { body: 'HEY!' },
          }
        end

        it 'returns guest' do
          expect(subject).to be_a GuestyAPI::Entities::GuestConversation
        end

        # rubocop:disable RSpec/MultipleExpectations
        it 'returns fields' do
          expect(subject.thread.dig(0, 'module')).to eq params[:module]
          expect(subject.thread.dig(0, 'sms', 'body')).to eq params[:sms][:body]
        end
        # rubocop:enable RSpec/MultipleExpectations
      end
    end
  end
end

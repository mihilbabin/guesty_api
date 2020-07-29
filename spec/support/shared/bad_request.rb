# frozen_string_literal: true

RSpec.shared_examples 'bad request' do
  before do
    stub_request(defined?(http_method) ? http_method : :get, url)
      .to_return(body: 'Bad Request', status: 400)
  end

  it 'throws API error' do
    expect { subject }.to raise_error(
      an_instance_of(GuestyAPI::APIError)
        .and(having_attributes(message: 'Bad Request', code: 400)),
    )
  end
end

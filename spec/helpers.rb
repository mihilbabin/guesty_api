# frozen_string_literal: true

module Helpers
  def fixture_file(path)
    File.open("#{__dir__}/fixtures/#{path}", 'r')
  end

  def api_root
    'https://api.guesty.com/api/v2'
  end
end

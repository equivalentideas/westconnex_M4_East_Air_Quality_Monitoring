require 'test_helper'

describe Sinatra::Application do
  it 'should politely greet visitors' do
    get '/'
    last_response.body.must_include 'Hello world!'
  end
end

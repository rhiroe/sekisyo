# frozen_string_literal: true

class TestApplication
  def call(_env)
    code   = 200
    body   = ['success']
    header = { 'Content-Type' => 'text/plain; charset=utf-8',
               'Content-Length' => body.sum(&:bytesize).to_s,
               'X-XSS-Protection' => '1; mode=block',
               'X-Content-Type-Options' => 'nosniff',
               'X-Frame-Options' => 'SAMEORIGIN' }
    [code, header, body]
  end
end

# TODO: add file property to sekisyo.yml and add test
RSpec.describe Sekisyo::Middleware do
  include Rack::Test::Methods

  let(:test_app) { TestApplication.new }
  let(:app) { described_class.new(test_app) }

  before { described_class.configuration.file_paths = 'spec/files/whitelists/sekisyo.yml' }

  describe '#initialize' do
    specify { expect { app }.not_to raise_error }
  end

  describe 'GET /pets' do
    it 'no params' do
      get '/pets'
      expect(last_response.status).to eq 200
    end

    it 'with permit params' do
      get '/pets?status[]=available'
      expect(last_response.status).to eq 200
    end

    it 'with not permit params' do
      get '/pets?evil=value'
      expect(last_response.status).to eq 400
    end
  end

  describe 'POST /pets' do
    it 'with required params' do
      params = { 'name' => 'bulldog', 'photo_urls' => ['http/example.com/sample.jpeg'] }
      post '/pets', params
      expect(last_response.status).to eq 200
    end

    it 'with all optional params' do
      params = { 'name' => 'bulldog', 'status' => 'available',
                 'photo_urls' => ['http/example.com/sample.jpeg'],
                 'category' => { 'id' => 1, 'name' => 'dog' },
                 'tags' => { 'id' => 1, 'name' => 'New' } }
      post '/pets', params
      expect(last_response.status).to eq 200
    end

    it 'no required params' do
      post '/pets', {}
      expect(last_response.status).to eq 400
    end

    it 'with different type params' do
      params = { 'name' => 'bulldog', 'photo_urls' => 'http/example.com/sample.jpeg' }
      post '/pets', params
      expect(last_response.status).to eq 400
    end

    it 'with invalid value params' do
      params = { 'name' => '', 'photo_urls' => 'http/example.com/sample.jpeg' }
      post '/pets', params
      expect(last_response.status).to eq 400
    end

    it 'with not permit params' do
      params = { 'name' => 'bulldog', 'evil' => 'value', 'photo_urls' => ['http/example.com/sample.jpeg'] }
      post '/pets', params
      expect(last_response.status).to eq 400
    end
  end

  describe 'GET /pets/{id}' do
    it 'with permit params' do
      get '/pets/1'
      expect(last_response.status).to eq 200
    end

    it 'with different type path params' do
      get '/pets/foo'
      expect(last_response.status).to eq 400
    end

    it 'with not permit params' do
      get '/pets/1?evil=value'
      expect(last_response.status).to eq 400
    end
  end

  describe 'PUT /pets/{id}' do
    it 'with required params' do
      params = { 'name' => 'bulldog', 'photo_urls' => ['http/example.com/sample.jpeg'] }
      put '/pets/1', params
      expect(last_response.status).to eq 200
    end

    it 'with all optional params' do
      params = { 'name' => 'bulldog', 'status' => 'available',
                 'photo_urls' => ['http/example.com/sample.jpeg'],
                 'category' => { 'id' => 1, 'name' => 'dog' },
                 'tags' => { 'id' => 1, 'name' => 'New' } }
      put '/pets/1', params
      expect(last_response.status).to eq 200
    end

    it 'no required params' do
      put '/pets/1', {}
      expect(last_response.status).to eq 400
    end

    it 'with different type path params' do
      params = { 'name' => 'bulldog', 'photo_urls' => ['http/example.com/sample.jpeg'] }
      put '/pets/foo', params
      expect(last_response.status).to eq 400
    end

    it 'with different type params' do
      params = { 'name' => 'bulldog', 'photo_urls' => 'http/example.com/sample.jpeg' }
      put '/pets/1', params
      expect(last_response.status).to eq 400
    end

    it 'with invalid value params' do
      params = { 'name' => '', 'photo_urls' => 'http/example.com/sample.jpeg' }
      put '/pets/1', params
      expect(last_response.status).to eq 400
    end

    it 'with not permit params' do
      params = { 'name' => 'bulldog', 'evil' => 'value', 'photo_urls' => ['http/example.com/sample.jpeg'] }
      put '/pets/1', params
      expect(last_response.status).to eq 400
    end
  end

  describe 'DELETE /pets/{id}' do
    it 'with permit params' do
      delete '/pets/1'
      expect(last_response.status).to eq 200
    end

    it 'with different type path params' do
      delete '/pets/foo'
      expect(last_response.status).to eq 400
    end

    it 'with not permit params' do
      delete '/pets/1?evil=value'
      expect(last_response.status).to eq 400
    end
  end
end

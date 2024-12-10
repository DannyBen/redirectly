require 'spec_helper'

describe App do
  let(:config_path) { 'spec/fixtures/redirects.ini' }

  context 'with a simple request' do
    subject { host_get 'search.localhost' }

    it 'redirects with a temporary status' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://search.com'
      expect(last_response.status).to eq 302
    end
  end

  context 'with a request that uses :args' do
    subject { host_get 'find.localhost/hello%20world' }

    it 'redirects and replaces the args in the target' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://search.com/?q=hello world'
    end
  end

  context 'with a request that uses :args in the domain name' do
    subject { host_get 'google.domain.com' }

    it 'redirects and replaces the args in the target' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://new-site.com/google'
    end
  end

  context 'with a request that uses wildcards in the path' do
    subject { host_get 'test.localhost' }

    it 'redirects' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://test.com/'
    end
  end

  context 'with a request that uses wildcards in the domain' do
    subject { host_get 'whatever.localhost' }

    it 'redirects' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://anything-else.com'
    end
  end

  context 'with a request that contains a query string' do
    subject { host_get 'test.localhost' }

    it 'forwards the query string to the target' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://test.com/'
    end

    context 'when the target already contains a query string' do
      subject { host_get 'query.com', add: 'me' }

      it 'properly appends the query string from the source to the target' do
        expect(subject).to be_redirection
        expect(last_response.location).to eq 'https://redir.com?already=have&query=string&add=me'
      end
    end
  end

  context 'with a request that uses a named splat' do
    subject { host_get 'anything.splat.localhost/1/2/3/4?5=6' }

    it 'redirects' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://example.com/1/2/3/4?5=6'
    end
  end

  context 'with a target that wants a permanent redirect' do
    subject { host_get 'perm.localhost' }

    it 'redirects with a permanent status' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://permanent.com'
      expect(last_response.status).to eq 301
    end
  end

  context 'with a target that wants a proxy' do
    subject { host_get url }

    let(:url) { 'proxy.localhost/path?query=string' }
    let(:parsed_response) { JSON.parse last_response.body }

    it 'reads and serves the content from the target' do
      expect(subject).to be_successful
      expect(last_response.content_type).to eq 'application/json'
      expect(parsed_response['path']).to eq '/basepath/path?query=string'
    end

    context 'when the target raises an error' do
      let(:url) { 'invalid-proxy.localhost' }

      it 'returns 502 Bad Gateway' do
        expect(subject).not_to be_successful
        expect(last_response.status).to eq 502
        expect(last_response.body).to include 'Bad Gateway'
      end
    end
  end

  context 'with an unknown request' do
    subject { host_get 'no.such.pattern/here' }

    it 'responds with a 404' do
      expect(subject).to be_not_found
    end
  end

  context 'when env var REDIRECTLY_RELOAD is set' do
    let(:app) { Redirectly::App.new config_path }

    before { ENV['REDIRECTLY_RELOAD'] = '1' }
    after { ENV['REDIRECTLY_RELOAD'] = nil }

    it 'reloads the INI file with each request' do
      expect(app).to receive(:ini_read).twice.and_call_original
      2.times { app.call(Rack::MockRequest.env_for('http://test.localhost/')) }
    end
  end
end

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
    subject { host_get 'search.lvh.me/hello%20world&+' }

    it 'redirects and replaces the args in the target' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://search.com/?q=hello+world%26%2B'
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
    subject { host_get 'test.lvh.me' }

    it 'redirects' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://test.com/'
    end
  end

  context 'with a request that uses wildcards in the domain' do
    subject { host_get 'whatever.lvh.me' }

    it 'redirects' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://anything-else.com'
    end
  end

  context 'with a request that contains a query string' do
    subject { host_get 'test.lvh.me' }

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

  context 'with a target that wants a permanent redirect' do
    subject { host_get 'perm.lvh.me' }

    it 'redirects with a permanent status' do
      expect(subject).to be_redirection
      expect(last_response.location).to eq 'https://permanent.com'
      expect(last_response.status).to eq 301
    end
  end

  context 'with an unknown request' do
    subject { host_get 'no.such.pattern/here' }

    it 'responds with a 404' do
      expect(subject).to be_not_found
    end
  end
end

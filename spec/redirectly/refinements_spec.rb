require 'spec_helper'

describe Refinements do
  using described_class

  describe String do
    describe '#comment?' do
      it 'returns true for a line that starts with a semicolon' do
        expect('; a nice comment'.comment?).to be true
      end

      it 'returns true for a line that starts with a hash' do
        expect('# a nice comment'.comment?).to be true
      end

      it 'returns false for anything else' do
        expect('not a nice comment'.comment?).to be false
      end
    end
  end
end

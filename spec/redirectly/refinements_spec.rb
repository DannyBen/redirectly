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

    describe '#section?' do
      it 'returns true for a line that looks like an INI section' do
        expect('[INI section]'.section?).to be true
      end

      it 'returns false for other lines' do
        expect('[Not a section'.section?).to be false
        expect('; [Not a section]'.section?).to be false
      end
    end

    describe '#ignored?' do
      it 'returns true for comments' do
        expect('; ignored'.ignored?).to be true
      end

      it 'returns true for empty lines' do
        expect(''.ignored?).to be true
      end

      it 'returns true for sections lines' do
        expect('[section]'.ignored?).to be true
      end

      it 'returns false for other lines' do
        expect('line'.ignored?).to be false
      end
    end
  end
end

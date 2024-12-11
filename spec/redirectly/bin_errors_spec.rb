describe 'bin/redirectly error handling' do
  it 'errors gracefully' do
    expect(`bin/redirectly no-such-file.ini`).to match_approval('bin/error')
  end
end

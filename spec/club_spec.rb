require 'club'
require 'byebug'

describe Transfermarkt::Club do
  before do
    @club = described_class.new(
      title: 'Zenit St. Petersburg',
      path: '/zenit-st-petersburg/startseite/verein/964/saison_id/2019',
      place: 1
    )

    @club.instance_variable_set(:@page, File.read("#{__dir__}/fixtures/club.html"))
  end

  describe '#fetch_players!' do
    it 'fetches players from page' do
      @club.fetch_players!

      expect(@club.players.count).to eq 25
      expect(@club.players.first[:name]).to eq 'Andrey Lunev'
      expect(@club.players.first[:price]).to eq 10_500_000
    end
  end
end

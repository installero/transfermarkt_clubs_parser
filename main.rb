require 'byebug'

require 'active_support/number_helper'

require_relative 'lib/club'

BASE_URL = 'https://www.transfermarkt.com'

# url = 'https://www.transfermarkt.com/zenit-st-petersburg/startseite/verein/964/saison_id/2019'
# players = Transfermarkt.players_by_club(url)
# price = Transfermarkt.club_price(url)

url = "#{BASE_URL}/premier-liga/tabelle/wettbewerb/RU1/saison_id/2019"

clubs = Transfermarkt.clubs_by_league(url)

sorted_clubs =
  clubs.sort_by do |club|
    club.fetch_players!
    club.price
  end

sorted_clubs.each do |club|
  price_string = ActiveSupport::NumberHelper.number_to_delimited(club.price, delimiter: ' ')
  puts "#{club.place}: #{club.title}, #{price_string}"
end

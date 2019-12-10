require 'date'
require 'nokogiri'
require 'open-uri'

require_relative 'transfermarkt'

module Transfermarkt
  class Club
    attr_accessor :title, :path, :place, :price, :players, :page

    def initialize(title:, path:, place:, price: nil, players: nil)
      @title = title
      @path = path
      @place = place
      @price = price
      @players = players
    end

    def fetch_page!
      @page ||= open("#{BASE_URL}#{path}") { |result| result.read }
    end

    def fetch_players!
      fetch_page!

      @players ||= begin
        document = Nokogiri::HTML(@page)
        document.css('table.items > tbody > tr').map do |tr_node|
          {
            name: tr_node.at('.hide-for-small').text,
            price: price_to_int(tr_node.at('.rechts.hauptlink').text),
            date: Date.parse(tr_node.css('.zentriert')[1].text)
          }
        end
      end
    end

    def price
      @players.sum { |player| player[:price] }
    end

    private

    def price_to_int(price)
      # "€10.50m  " -> 10_500_000
      price = price.gsub(/[^€\d\.a-z]/, '')

      unless price[0] == '€'
        raise ArgumentError.new("Expected price in euros, got #{price}")
      end

      price = price[1..-1]

      price.to_f * magnitude_to_integer(price[-1])
    end

    def magnitude_to_integer(s)
      return 1_000_000 if s == 'm'
      return 1_000 if s == 'k'

      raise ArgumentError.new("Expected m or k, got #{s}")
    end
  end
end

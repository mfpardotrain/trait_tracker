require 'json'
require "net/http"
require_relative 'champions'
require_relative 'traits'

class TftData
    include Singleton

    attr_reader :champions, :traits, :potential_teams

    CURRENT_SET = "13"

    def initialize
        raw = JSON.parse(get_request("https://raw.communitydragon.org/latest/cdragon/tft/en_us.json").body)
        raw_champions = raw["sets"][CURRENT_SET]["champions"]
        raw_traits = raw["sets"][CURRENT_SET]["traits"] 

        @champions = Champions.new(raw_champions)
        @traits = Traits.new(raw_traits)
        @potential_teams = read_potential_teams
        puts "No potential team data" if @potential_teams.to_a.length < 500
    end

    def read_potential_teams
        raw_csv = CSV.read("combinations.csv")

        raw_csv.map do |row|
            names = row.first(7)
            champions.build_team_from_names(names)
        end.compact
    end

    def get_request(url)
        uri = URI(url)
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Get.new uri
    
          http.request request
        end
    end
end
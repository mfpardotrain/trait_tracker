require_relative 'tft_data'
require_relative 'team'
require 'csv'

class Controller
    TOTAL_TRAITS = 8
    TEAM_SIZE = 7

    def initialize
        @teams_of_seven = read_potential_teams
        require 'pry'
        binding.pry
    end

    def champions
        TftData.instance.champions
    end

    def traits
        TftData.instance.traits
    end

    def read_potential_teams
        CSV.read("combinations.csv")
    end

    # For potential teams initialization
    def build_teams
        tt = {}
        combinations = champions.champions_with_traits.combination(TEAM_SIZE).to_a
        i = 0
        combinations.map do |team|
            i += 1
            puts "n=#{i / 100000} #{100 * i / 133784560.0}%" if i % 100000 == 0
            t = Team.new(team)

            # use for teams statistics
            if tt.keys.include?(t.total_active)
                tt[t.total_active] += 1
            else
                tt[t.total_active] = 1
            end

            t if t.total_active >= TOTAL_TRAITS
        end.compact
    end

    def write_data
        CSV.open("combinations.csv", "w") do |csv|
            @teams_of_seven.each do |team|
                csv << team.get_champs + [team.active_traits] + [team.inactive_traits] + [team.raw_team]
            end
        end
    end
end
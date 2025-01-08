require_relative 'tft_data'
require_relative 'team'
require 'csv'

class PotentialTeamBuilder
    TOTAL_TRAITS = 8
    TEAM_SIZE = 6

    def initialize
        @potential_teams = build_teams
        require 'pry'
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
            puts "n=#{i / 100000} #{100 * i / 133784560.0}%" if i % 1000000 == 0
            team_obj = Team.new(team)

            # use for teams statistics
            if tt.keys.include?(t.total_active)
                tt[t.total_active] += 1
            else
                tt[t.total_active] = 1
            end

            team_obj if team_obj.total_active >= TOTAL_TRAITS
        end.compact
    end

    def write_data
        CSV.open("#{Time.now.strftime("%d-%m-%Y")}_combinations.csv", "w") do |csv|
            @build_teams.each do |team|
                csv << team.get_champs + [team.active_traits] + [team.inactive_traits] + [team.raw_team]
            end
        end
    end
end
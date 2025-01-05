require_relative "tft_data"

class DecisionEngine
        require 'pry'
    def initialize
        team = ["Ziggs", "Silco", "Irelia", "Lux", "Gangplank", "Swain"]
        cur_team = champions.build_team_from_names(team)
        find_best_champions(cur_team, 3)
    end

    def self.find_best_champions(team)
        filtered = get_potential_teams(team)
        current_probable_teams = get_current_state(filtered, team)

        top_units = {}
        current_probable_teams.each do |size, teams| 
            cur_freq = {}
            teams.each { |team| get_unit_frequencies(team, cur_freq) }
            top_units[size] = cur_freq
        end

        # TODO: Handle different team sizes
        top_units[top_units.keys.max].sort_by(&:last).reverse
        top_units
    end

    def self.get_potential_teams(team)
        if team.empty?
            filtered = potential_teams
        else
            filtered = potential_teams.select { |potential_team| !(team.to_a & potential_team.to_a).empty? }
        end
        filtered
    end

    def self.champions
        TftData.instance.champions
    end

    def self.potential_teams
        TftData.instance.potential_teams
    end

    def self.get_unit_frequencies(team, freq={})
        team.to_a.each do |champ|
            if freq.keys.include?(champ.name)
                freq[champ.name] += 1
            else
                freq[champ.name] = 1
            end
        end
        freq
    end

    def self.get_champ_mappings(cur_teams)
        freq = {}
        cur_teams.each do |team|
            team.to_a.each do |champ|
                if freq.keys.include?(champ.name)
                    freq[champ.name] = get_unit_frequencies(team, freq[champ.name])
                else
                    freq[champ.name] = get_unit_frequencies(team, {})
                end
            end
        end
        freq 
    end

    def self.get_current_state(filtered_teams, cur_team)
        current_state = {}
        filtered_teams.each do |potential_team| 
            overlap = cur_team.to_a & potential_team.to_a
            n_champs = overlap.length
            if current_state.keys.include?(n_champs)
                current_state[n_champs] << potential_team
            else
                current_state[n_champs] = [potential_team]
            end
        end
        current_state
    end
end
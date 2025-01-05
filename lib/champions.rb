require_relative 'champion'
require_relative 'team'

class Champions
    HIGHEST_ALLOWED_COST = 4

    def initialize(champion_data)
        @raw_champions = champion_data
    end
    
    def all_champions
        @all_champions ||= @raw_champions.map do |champion|
            Champion.new(champion)
        end
    end

    def champions_with_traits
        @champions_with_traits ||= all_champions.filter { |champion| champion.traits.length > 0 && champion.cost <= HIGHEST_ALLOWED_COST }
    end

    def find_from_name(name)
        all_champions.select { |champ| champ.name == name }.first
    end

    def build_team_from_names(arr)
        Team.new(arr.map { |name| find_from_name(name) })
    end
end
require_relative 'tft_data'

class Team
    attr_reader :raw_team, :emblems

    def initialize(team_data, emblems={})
        @raw_team = team_data
        @emblems = emblems
    end

    def trait_data
        TftData.instance.traits
    end

    def trait_counts
        @trait_counts = {}
        @raw_team.each do |champion|
            champion.traits.each do |trait|
                if @trait_counts.keys.include?(trait)
                    @trait_counts[trait] += 1
                else
                    @trait_counts[trait] = 1
                end
            end
        end
        @trait_counts = @emblems.stringify_keys.merge(@trait_counts){|_,a,b| a+b}
    end

    def active_traits
        trait_counts.select do |trait_name, n_champs|
            trait = trait_data.non_unique_traits.select { |trait| trait.name == trait_name}.first
            n_champs >= trait.min_requirements
        end.compact
    end

    def get_active_champs
        @raw_team.select do |champ|
            (champ.traits & active_traits.keys).length > 0 
        end
    end

    def inactive_traits
        @inactive_traits ||= trait_counts.select do |trait_name, n_champs|
            trait = trait_data.non_unique_traits.select { |trait| trait.name == trait_name}.first
            n_champs < trait.min_requirements
        end
    end

    def total_active
        active_traits.keys.length
    end

    def get_champ_names
        @raw_team.map(&:name)
    end
    
    def to_a
        @raw_team
    end

    def empty?
        @raw_team.empty?
    end
end
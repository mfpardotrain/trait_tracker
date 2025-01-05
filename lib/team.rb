require_relative 'tft_data'

class Team
    attr_reader :raw_team

    def initialize(team_data)
        @raw_team = team_data
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
        @trait_counts
    end

    def active_traits
        @active_traits ||= trait_counts.select do |trait_name, n_champs|
            n_champs >= trait_data.non_unique_traits.select { |trait| trait.name == trait_name}.first.min_requirements
        end
    end

    def inactive_traits
        @inactive_traits ||= trait_counts.select do |trait_name, n_champs|
            n_champs < trait_data.non_unique_traits.select { |trait| trait.name == trait_name}.first.min_requirements
        end
    end

    def total_active
        active_traits(trait_data).keys.length
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
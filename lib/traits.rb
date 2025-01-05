require_relative 'trait'

class Traits
    def initialize(trait_data)
        @raw_traits = trait_data
    end
    
    def all_traits
        @all_traits ||= @raw_traits.map do |trait|
            Trait.new(trait)
        end
    end

    def non_unique_traits
        @non_unique_traits ||= all_traits.filter { |trait| !trait.is_unique }
    end
end
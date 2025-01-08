class Trait
    attr_reader :name, :min_requirements, :is_unique, :score

    def initialize(trait_data)
        @name = trait_data["name"]
        @min_requirements = trait_data["effects"].first["minUnits"]
        @is_unique = trait_data["effects"].length == 1
        @score = 1.0 / min_requirements
    end
end
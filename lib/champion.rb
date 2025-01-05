class Champion
    attr_reader :name, :traits, :icon, :cost

    def initialize(champion_data)
        @name = champion_data["name"]
        @traits = champion_data["traits"]
        @icon = champion_data["icon"]
        @cost = champion_data["cost"]
    end
end
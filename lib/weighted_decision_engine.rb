require_relative "tft_data"

class WeightedDecisionEngine
    require 'pry'

    LOOK_AHEAD = 3
    TRAIT_REQUIREMENT = 8
    MAX_TEAM_LENGTH = 7

    def initialize
        @solutions = []
        @solutions_names = []
    end

    def champions(used=[])
        TftData.instance.champions.filter_by_champ_names(used)
    end

    def potential_teams
        TftData.instance.potential_teams
    end
    
    def traits
        TftData.instance.traits.non_unique_traits
    end

    def score_champions(team)
        out = {}
        champions(team.get_champ_names).each do |champ|
            champ_score = champ.traits.reduce(0) do |score, trait|
                score + get_trait_score(trait, team)
            end
            # Change to champ.name if we dont want the whole object as a key
            out[champ.name] = champ_score
        end
        out
    end

    def get_trait_score(trait_name, team)
        traits.each do |trait|
            if trait.name == trait_name
                requirements = trait.min_requirements - team.trait_counts.fetch(trait.name, 0)
                return 0.0 if requirements <= 0
                return (1.0 / (requirements * 2))
            end
        end
    end

    def find_best_champions(team)
        {0 => score_champions(team)}
    end

    # For potential teams initialization
    def build_teams(team)
        return [] if team.to_a.length < 3
        emblems = team.emblems
        filtered_by_inactive = champions(team.get_champ_names).filter { |champion| (champion.traits & team.inactive_traits.keys).length > 0 }

        # slow performance with lots of champions
        # if filtered_by_inactive.length < 12
        #     added_names = score_champions.except(*team.get_champ_names).sort_by(&:last).last(12).to_h.keys
        #     added_champs = TftData.instance.champions.build_team_from_names(added_names).to_a
        #     combinations = (filtered_by_inactive + added_champs).combination(LOOK_AHEAD).to_a
        # else
        #     combinations = filtered_by_inactive.combination(LOOK_AHEAD).to_a
        # end
        added_names = score_champions(team).except(*team.get_champ_names).sort_by(&:last).last(10).to_h.keys
        added_champs = TftData.instance.champions.build_team_from_names(added_names).to_a
        combinations = added_champs.combination(LOOK_AHEAD).to_a

        puts "comb #{combinations.length}"
        combinations.each do |comb_team|
            team_obj = Team.new(comb_team + team.to_a, emblems)
            active_champs = Team.new(team_obj.get_active_champs, emblems)

            if active_champs.to_a.length > 7
                six_combinations = active_champs.get_champ_names.combination(6).to_a
                seven_combinations = active_champs.get_champ_names.combination(7).to_a 
                six_and_seven = (six_combinations + seven_combinations).uniq

                puts "six sev #{six_and_seven.length} comb #{combinations.length} mult #{six_and_seven.length * combinations.length}"
                six_and_seven.each do |champ_names|
                    team_obj2 = TftData.instance.champions.build_team_from_names(champ_names, emblems)
                    if team_obj2.active_traits.keys.length >= TRAIT_REQUIREMENT && !@solutions_names.include?(champ_names.sort)
                        @solutions << team_obj2
                    end
                    @solutions_names << champ_names.sort
                end
            else
                if team_obj.active_traits.keys.length >= TRAIT_REQUIREMENT && !@solutions_names.include?(active_champs.get_champ_names.sort)
                    @solutions << active_champs
                end
                @solutions_names << team_obj.get_champ_names.sort
            end
        end
        @solutions.uniq.sort_by { |el| el.to_a.length }
    end
end
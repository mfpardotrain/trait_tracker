require_relative 'team'
require 'glimmer-dsl-libui'
require_relative 'decision_engine'

class Entrypoint
    include Glimmer
    def champions
        TftData.instance.champions
    end

    def run
        row = 0
        col = 0
        cur_team = []
        current_target = []
        suggested_champs = []
        second_suggestion = []

        window('Champion Helper', 870, 900) {
          margined true
          vertical_box {
            grid {
                padded true

                champions.champions_with_traits.sort_by(&:name).each_with_index do |champ, index|
                    if col == 8
                        row += 1
                        col = 0
                    end

                    checkbox("#{champ.name}") {
                        # Swap for different hero orientation
                        left row
                        top col
                        hexpand true

                        on_toggled do |checkbox|
                            if checkbox.checked?
                                cur_team << [checkbox.text]
                            else
                                cur_team.delete([checkbox.text])
                            end

                            team = champions.build_team_from_names(cur_team.flatten)
                            new_champs = DecisionEngine.find_best_champions(team)
                            suggested_champs.clear()

                            top_champs = new_champs[new_champs.keys.max].sort_by(&:last).reverse

                            top_champs.each do |champ|
                                next if cur_team.flatten.include?(champ[0])
                                suggested_champs << champ
                            end

                            if new_champs.keys.length > 1
                                second_suggestion.clear()
                                lower_champs = new_champs[new_champs.keys.max - 1].sort_by(&:last).reverse
                                lower_champs.each do |champ|
                                    next if cur_team.flatten.include?(champ[0])
                                    second_suggestion << champ
                                end
                            end

  
                            current_target.clear()
                            target_team = DecisionEngine.get_potential_teams(team)
                            top_ten_teams = target_team[target_team.keys.max].first(10)
                            top_ten_teams.each do |top_team|
                                current_target << top_team.to_a.map do |el| 
                                    color = :black
                                    color = :dark_green if team.get_champ_names.include?(el.name) 
                                    [el.name, color] 
                                end
                            end
                        end
                    }
                    col += 1
                end
            }

            table {
                text_color_column("Champ 1")
                text_color_column("Champ 2")
                text_color_column("Champ 3")
                text_color_column("Champ 4")
                text_color_column("Champ 5")
                text_color_column("Champ 6")
                text_color_column("Champ 7")

                cell_rows current_target
            }
            horizontal_box {
                table {
                    text_column("Current Team")
                    cell_rows cur_team
                }  
                table {
                    text_column("Suggested Champs")
                    text_column("Total Comps")
                    cell_rows suggested_champs
                }
                table {
                    text_column("Increase Options")
                    text_column("Total Comps")
                    cell_rows second_suggestion
                }
 
            }
          }
        }.show
    end
end





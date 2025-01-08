require_relative "lib/potential_team_builder"
require_relative "lib/decision_engine"
require_relative "lib/weighted_decision_engine"
require_relative "lib/entrypoint"

task default: %w[test]

task :run do
    Entrypoint.new.run
end
 
task :build_teams do
    PotentialTeamBuilder.new.write_data
end

task :test do
    WeightedDecisionEngine.new
end

require "rubocop/rake_task"
require "standard/rake"
require_relative "lib/controller"
require_relative "lib/decision_engine"
require_relative "lib/entrypoint"

task default: %w[test]

task :run do
#   Controller.new
#   DecisionEngine.new
    Entrypoint.new.run
end

task :test do
    puts "no tests"
end

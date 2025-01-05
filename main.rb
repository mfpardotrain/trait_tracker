require "rubocop/rake_task"
require_relative "lib/entrypoint"
require "standard/rake"

begin
    Entrypoint.new.run
rescue Exception => e
    File.open("except.log") do |f|
      f.puts e.inspect
      f.puts e.backtrace
    end
end
require 'lib/bef-1.0.0/bef.rb'

def tick args
  args.state.db ||= Bef::Database.new
  args.state.db.get("select * from modules") do |result|
    puts result
  end

  args.state.db.get("select * from Guard") do |result|
    puts result
  end

  # args.outputs.labels  << [640, 540, 'Hello World!', 5, 1]
end
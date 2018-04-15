RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  sequence(:random_id) {|n| @random_ids ||= (1..100000).to_a.shuffle; @random_ids[n] }
end

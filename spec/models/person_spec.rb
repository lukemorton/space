require 'rails_helper'

RSpec.describe Person do
  it { should validate_presence_of(:name) }
end

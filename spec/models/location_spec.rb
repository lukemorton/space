require 'rails_helper'

RSpec.describe Location do
  it { should validate_presence_of(:name) }
end

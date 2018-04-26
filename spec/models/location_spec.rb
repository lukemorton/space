require 'rails_helper'

RSpec.describe Location do
  it { should validate_presence_of(:name) }
  it { should have_one(:dock) }
  it { should have_many(:establishments) }
end

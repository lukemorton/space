require 'rails_helper'

RSpec.describe Location do
  it { should have_many(:establishments) }
  it { should have_many(:ships) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
end

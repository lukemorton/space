require 'rails_helper'

RSpec.describe Ship do
  it { should belong_to(:dock) }
  it { should belong_to(:location) }
  it { should have_many(:crew) }
  it { should validate_presence_of(:fuel) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
end

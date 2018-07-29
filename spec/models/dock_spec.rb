require 'rails_helper'

RSpec.describe Dock do
  it { should belong_to(:location) }
  it { should have_many(:ships) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
end

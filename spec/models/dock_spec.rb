require 'rails_helper'

RSpec.describe Dock do
  it { should belong_to(:location) }
  it { should have_many(:ships) }
end

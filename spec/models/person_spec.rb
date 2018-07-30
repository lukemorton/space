require 'rails_helper'

RSpec.describe Person do
  it { should belong_to(:location) }
  it { should belong_to(:ship) }
  it { should validate_presence_of(:name) }
end

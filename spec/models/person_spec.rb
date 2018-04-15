require 'rails_helper'

RSpec.describe Person do
  it { should validate_presence_of(:name) }
  it { should belong_to(:location) }
  it { should belong_to(:ship) }
end

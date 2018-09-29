require 'rails_helper'

RSpec.describe ShipComputer do
  it { should belong_to(:ship) }
  it { should validate_presence_of(:reference) }
end

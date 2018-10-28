require 'rails_helper'

RSpec.describe ShipBoardingRequest do
  it { should belong_to(:ship) }
  it { should belong_to(:requester) }
end

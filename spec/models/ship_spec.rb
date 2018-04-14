require 'rails_helper'

RSpec.describe Ship do
  it { should belong_to(:location) }
end

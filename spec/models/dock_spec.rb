require 'rails_helper'

RSpec.describe Dock do
  it { should belong_to(:location) }
end

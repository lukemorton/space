require_relative '../../../../lib/space/computers/euclidean_distance_calculator'

RSpec.describe Space::Computers::EuclideanDistanceCalculator do
  let(:current_location) { instance_double('Space::Locations::Location', coordinates: [1, 2, 3]) }
  let(:another_location) { instance_double('Space::Locations::Location', coordinates: [4, 5, 6]) }

  subject do
    described_class.new
  end

  it 'returns distance between two locations' do
    expect(subject.distance_between(current_location, another_location)).to be_within(0.001).of(5.196)
  end
end

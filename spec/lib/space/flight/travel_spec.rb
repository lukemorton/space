require_relative '../../../../lib/space/flight/travel'

RSpec.describe Space::Flight::Travel do
  context 'when travelling from station to station' do
    let(:current_station) { double }
    let(:destination_station) { double }
    let(:person) { double(location: current_station, :location= => nil) }

    subject { described_class.new.travel(person, to: destination_station) }

    it 'allows valid travel' do
      expect(subject).to be_successful
    end

    context 'and trying to travel to current station' do
      let(:destination_station) { current_station }

      it 'disallows valid travel' do
        expect(subject).to_not be_successful
      end

      it 'provides an error' do
        expect(subject.errors).to include(:destination_station)
      end
    end
  end
end

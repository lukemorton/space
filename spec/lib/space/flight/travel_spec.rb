require_relative '../../../../lib/space/flight/travel'

RSpec.describe Space::Flight::Travel do
  context 'when travelling from station to station' do
    let(:current_station) { instance_double('Location') }
    let(:destination_station) { instance_double('Location') }
    let(:person) { double(location: current_station, :location= => nil) }

    let(:use_case) do
      described_class.new(
        location_gateway: instance_double('Space::Locations::LocationGateway', find: destination_station),
        person_gateway: instance_double('Space::Flight::PersonGateway', find: person, update: true)
      )
    end

    subject { use_case.travel(1, to: destination_station) }

    it 'allows valid travel' do
      expect(subject).to be_successful
    end

    context 'and trying to travel to current station' do
      let(:destination_station) { current_station }

      it 'disallows valid travel' do
        expect(subject).to_not be_successful
      end

      it 'provides an error' do
        expect(subject.errors).to include(:destination_location)
      end
    end
  end
end

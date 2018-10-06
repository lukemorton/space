require 'rails_helper'

RSpec.describe ShipPresenter do
  let(:computers) { double }
  let(:destinations) { [double(id: 1, coordinates: [1, 2, 3], within_ship_fuel_range?: true, just_within_ship_fuel_range?: false)] }
  let(:ship) { double(id: 1, computers: computers, destinations: destinations, location: double(id: 1)) }

  subject { described_class.new(ship) }

  it 'has an id' do
    expect(subject.id).to be(ship.id)
  end

  it 'has a computers' do
    expect(subject.computers).to be(computers)
  end

  context 'destinations' do
    subject { described_class.new(ship).destinations }

    it 'have ids' do
      expect(subject.first.id).to be(ship.destinations.first.id)
    end

    it 'have coordinates' do
      expect(subject.first.coordinates).to eq('1,2,3')
    end

    it 'can be checked?' do
      expect(subject.first).to be_checked
    end

    it 'can be disabled?' do
      expect(subject.first).to_not be_disabled
    end

    it 'has fuel to travel status' do
      expect(subject.first.fuel_to_travel_status).to eq('success')
    end

    context 'when not enough fuel to travel destination' do
      let(:destinations) { [double(id: 1, within_ship_fuel_range?: false, just_within_ship_fuel_range?: false)] }

      it 'should be disabled' do
        expect(subject.first).to be_disabled
      end

      it 'should be danger fuel to travel status' do
        expect(subject.first.fuel_to_travel_status).to eq('danger')
      end
    end

    context 'when just about enough fuel to travel destination' do
      let(:destinations) { [double(id: 1, within_ship_fuel_range?: true, just_within_ship_fuel_range?: true)] }

      it 'should be danger fuel to travel status' do
        expect(subject.first.fuel_to_travel_status).to eq('warning')
      end
    end
  end

  context 'ship fuel' do
    context 'when ship has high fuel level' do
      let(:ship) { double(fuel: 1000, low_on_fuel?: false, out_of_fuel?: false) }

      it 'has ship fuel with delimiters' do
        expect(subject.fuel).to eq('1,000')
      end

      it 'has ship fuel status of success' do
        expect(subject.fuel_status).to eq('success')
      end
    end

    context 'when ship has low fuel' do
      let(:ship) { double(fuel: 10, low_on_fuel?: true, out_of_fuel?: false) }

      it 'has ship fuel status of warning' do
        expect(subject.fuel_status).to eq('warning')
      end
    end

    context 'when ship has no fuel' do
      let(:ship) { double(fuel: 0, low_on_fuel?: false, out_of_fuel?: true) }

      it 'has ship fuel status of danger' do
        expect(subject.fuel_status).to eq('danger')
      end
    end
  end

  it 'has ship hull' do
    expect(subject.hull).to eq('100%')
  end

  it 'has ship hull status' do
    expect(subject.hull_status).to eq('success')
  end

  it 'has ship shields' do
    expect(subject.shields).to eq('100%')
  end

  it 'has ship shields status' do
    expect(subject.shields_status).to eq('success')
  end
end

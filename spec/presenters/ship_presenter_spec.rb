require 'rails_helper'

RSpec.describe ShipPresenter do
  let(:computers) { double }
  let(:locations) { double }
  let(:ship) { double }

  subject do
    described_class.new(computers: computers, locations: locations, ship: ship)
  end

  it 'has a computers' do
    expect(subject.computers).to be(computers)
  end

  it 'has a locations' do
    expect(subject.locations).to be(locations)
  end

  it 'has a ship' do
    expect(subject.ship).to be(ship)
  end

  context 'ship fuel' do
    context 'when ship has high fuel level' do
      let(:ship) { double(fuel: 1000) }

      it 'has ship fuel with delimiters' do
        expect(subject.ship_fuel).to eq('1,000')
      end

      it 'has ship fuel status of success' do
        expect(subject.ship_fuel_status).to eq('success')
      end
    end

    context 'when ship has low fuel' do
      let(:ship) { double(fuel: 10) }

      it 'has ship fuel status of warning' do
        expect(subject.ship_fuel_status).to eq('warning')
      end
    end

    context 'when ship has no fuel' do
      let(:ship) { double(fuel: 0) }

      it 'has ship fuel status of danger' do
        expect(subject.ship_fuel_status).to eq('danger')
      end
    end
  end

  it 'has ship hull' do
    expect(subject.ship_hull).to eq('100%')
  end

  it 'has ship hull status' do
    expect(subject.ship_hull_status).to eq('success')
  end

  it 'has ship shields' do
    expect(subject.ship_shields).to eq('100%')
  end

  it 'has ship shields status' do
    expect(subject.ship_shields_status).to eq('success')
  end
end

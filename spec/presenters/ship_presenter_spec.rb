require 'rails_helper'

RSpec.describe ShipPresenter do
  let(:computers) { double }
  let(:destinations) { [double(id: 1)] }
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

    it 'can be checked?' do
      expect(subject.first).to be_checked
    end

    it 'can be disabled?' do
      expect(subject.first).to be_disabled
    end
  end

  context 'ship fuel' do
    context 'when ship has high fuel level' do
      let(:ship) { double(fuel: 1000) }

      it 'has ship fuel with delimiters' do
        expect(subject.fuel).to eq('1,000')
      end

      it 'has ship fuel status of success' do
        expect(subject.fuel_status).to eq('success')
      end
    end

    context 'when ship has low fuel' do
      let(:ship) { double(fuel: 10) }

      it 'has ship fuel status of warning' do
        expect(subject.fuel_status).to eq('warning')
      end
    end

    context 'when ship has no fuel' do
      let(:ship) { double(fuel: 0) }

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

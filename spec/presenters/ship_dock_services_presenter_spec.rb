require 'rails_helper'

RSpec.describe ShipDockServicesPresenter do
  let(:current_person) { double }

  subject { described_class.new(current_person) }

  it 'has an refuel_options' do
    expect(subject.refuel_options).to_not be_empty
  end

  context 'fuel options' do
    context 'full tank' do
      subject { described_class.new(current_person).refuel_options.first }

      it 'has type' do
        expect(subject.type).to eq(:full_tank)
      end

      it 'has formatted cost' do
        expect(subject.cost).to eq('λ300.00')
      end

      it 'is checked' do
        expect(subject).to be_checked
      end

      it 'has human label' do
        expect(subject.label).to eq('Full tank')
      end
    end

    context 'half tank' do
      subject { described_class.new(current_person).refuel_options.last }

      it 'has type' do
        expect(subject.type).to eq(:half_tank)
      end

      it 'has formatted cost' do
        expect(subject.cost).to eq('λ150.00')
      end

      it 'is checked' do
        expect(subject).to_not be_checked
      end

      it 'has human label' do
        expect(subject.label).to eq('Half tank')
      end
    end
  end
end

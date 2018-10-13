require 'rails_helper'

RSpec.describe ShipDockServicesPresenter do
  let(:full_tank_option) { double(type: :full_tank, cost: Money.new(300_00), affordable_for_person?: true) }
  let(:half_tank_option) { double(type: :half_tank, cost: Money.new(150_00), affordable_for_person?: true) }

  let(:dock_services) do
    double(refuel_service: double(options: [full_tank_option, half_tank_option]))
  end

  subject { described_class.new(dock_services) }

  it 'has an refuel_options' do
    expect(subject.refuel_options).to_not be_empty
  end

  it 'can have refuel disabled' do
    expect(subject).to respond_to(:refuel_disabled?)
  end

  context 'when all refuel options are affordable' do
    let(:full_tank_option) { double(type: :full_tank, cost: Money.new(300_00), affordable_for_person?: true) }
    let(:half_tank_option) { double(type: :half_tank, cost: Money.new(150_00), affordable_for_person?: true) }

    it 'should not disable refueling' do
      expect(subject).to_not be_refuel_disabled
    end
  end

  context 'when some refuel options are unaffordable' do
    let(:full_tank_option) { double(type: :full_tank, cost: Money.new(300_00), affordable_for_person?: false) }
    let(:half_tank_option) { double(type: :half_tank, cost: Money.new(150_00), affordable_for_person?: true) }

    it 'should not disable refueling' do
      expect(subject).to_not be_refuel_disabled
    end
  end

  context 'when all refuel options are unaffordable' do
    let(:full_tank_option) { double(type: :full_tank, cost: Money.new(300_00), affordable_for_person?: false) }
    let(:half_tank_option) { double(type: :half_tank, cost: Money.new(150_00), affordable_for_person?: false) }

    it 'should disable refueling' do
      expect(subject).to be_refuel_disabled
    end
  end

  describe 'full tank option' do
    subject { described_class.new(dock_services).refuel_options.first }

    it 'has type' do
      expect(subject.type).to eq(:full_tank)
    end

    it 'has formatted cost' do
      expect(subject.cost).to eq('λ300.00')
    end

    it 'can be checked' do
      expect(subject).to respond_to(:checked?)
    end

    it 'can be disabled' do
      expect(subject).to respond_to(:disabled?)
    end

    it 'has human label' do
      expect(subject.label).to eq('Full tank')
    end

    context 'and is afforable to person' do
      let(:full_tank_option) { double(type: :full_tank, cost: Money.new(300_00), affordable_for_person?: true) }

      it 'is not disabled' do
        expect(subject).to_not be_disabled
      end

      it 'has cost status of success' do
        expect(subject.cost_status).to eq('success')
      end
    end

    context 'and is not afforable to person' do
      let(:full_tank_option) { double(type: :full_tank, cost: Money.new(300_00), affordable_for_person?: false) }

      it 'is is disabled' do
        expect(subject).to be_disabled
      end

      it 'has cost status of danger' do
        expect(subject.cost_status).to eq('danger')
      end
    end
  end

  describe 'half tank option' do
    subject { described_class.new(dock_services).refuel_options.last }

    it 'has type' do
      expect(subject.type).to eq(:half_tank)
    end

    it 'has formatted cost' do
      expect(subject.cost).to eq('λ150.00')
    end

    it 'can be checked' do
      expect(subject).to respond_to(:checked?)
    end

    it 'can be disabled' do
      expect(subject).to respond_to(:disabled?)
    end

    it 'has human label' do
      expect(subject.label).to eq('Half tank')
    end

    context 'and is afforable to person' do
      let(:half_tank_option) { double(type: :half_tank, cost: Money.new(150_00), affordable_for_person?: true) }

      it 'is not disabled' do
        expect(subject).to_not be_disabled
      end

      it 'has cost status of success' do
        expect(subject.cost_status).to eq('success')
      end
    end

    context 'and is not afforable to person' do
      let(:half_tank_option) { double(type: :half_tank, cost: Money.new(150_00), affordable_for_person?: false) }

      it 'is is disabled' do
        expect(subject).to be_disabled
      end

      it 'has cost status of danger' do
        expect(subject.cost_status).to eq('danger')
      end
    end
  end
end

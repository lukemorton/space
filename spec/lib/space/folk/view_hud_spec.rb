require_relative '../../../../lib/space/folk/view_hud'
require 'money'

RSpec.describe Space::Folk::ViewHud do
  context 'when viewing a persons hud' do
    let(:location) { instance_double('Space::Locations::Location', id: 2) }
    let(:ship) { instance_double('Space::Flight::Ship', id: 3) }
    let(:person) { instance_double('Space::Folk::Person', id: 1, location: location, name: 'Luke', ship: ship) }
    let(:person_gateway) { instance_double('Space::Folk::PersonGateway', find: person) }

    let(:money_gateway) { instance_double('Space::Folk::MoneyGateway') } #, bank_balance: Money.new(10_00)

    let(:use_case) do
      described_class.new(
        money_gateway: money_gateway,
        person_gateway: person_gateway
      )
    end

    subject { use_case.view(1) }

    it 'has id' do
      expect(subject.id).to eq(person.id)
    end

    it 'has name' do
      expect(subject.name).to eq(person.name)
    end

    it 'has location' do
      expect(subject.location).to eq(person.location)
    end

    it 'has ship' do
      expect(subject.ship).to eq(person.ship)
    end
  end
end

require 'rails_helper'

RSpec.describe CurrentPersonPresenter do
  let(:bank_balance) { Money.new(20_00) }
  let(:person) { double(bank_balance: bank_balance) }

  subject { described_class.new(person) }

  it 'has an bank_balance' do
    expect(subject.bank_balance).to eq(bank_balance.format)
  end
end

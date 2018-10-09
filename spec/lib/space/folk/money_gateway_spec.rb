require_relative '../../../../lib/space/folk/money_gateway'

RSpec.describe Space::Folk::MoneyGateway do
  context 'when initializing bank account' do
    let(:double_entry) { class_double('DoubleEntry', account: nil, transfer: nil) }
    let(:person) { instance_double('Space::Folk::Person') }
    let(:seed) { double }
    let(:bank) { double }

    subject { described_class.new(double_entry: double_entry).initialize_bank(person) }

    it 'should load seed account' do
      subject
      expect(double_entry).to have_received(:account).with(:seed)
    end

    it 'should load bank account' do
      subject
      expect(double_entry).to have_received(:account).with(:bank, scope: person)
    end

    it 'should transfer from seed to personal bank' do
      allow(double_entry).to receive(:account).with(:seed).and_return(seed)
      allow(double_entry).to receive(:account).with(:bank, scope: person).and_return(bank)

      subject

      expect(double_entry).to have_received(:transfer).with(Money.new(Space::Folk::MoneyGateway::INITIAL_BANK_BALANCE), a_hash_including(
        from: seed,
        to: bank,
        code: :initialize
      ))
    end
  end

  context 'when getting bank balance' do
    let(:double_entry) { class_double('DoubleEntry', account: bank) }
    let(:person) { instance_double('Space::Folk::Person') }
    let(:bank) { double(balance: Money.new(50_00)) }

    subject { described_class.new(double_entry: double_entry).bank_balance(person) }

    it 'should load bank account' do
      subject
      expect(double_entry).to have_received(:account).with(:bank, scope: person)
    end

    it 'should return bank balance' do
      expect(subject).to eq(bank.balance)
    end
  end

  context 'when paying seed' do
    let(:double_entry) { class_double('DoubleEntry', account: nil, transfer: nil) }
    let(:person) { instance_double('Space::Folk::Person') }
    let(:seed) { double }
    let(:bank) { double }

    subject { described_class.new(double_entry: double_entry).pay_seed(person, Money.new(10_00)) }

    it 'should load seed account' do
      subject
      expect(double_entry).to have_received(:account).with(:seed)
    end

    it 'should load bank account' do
      subject
      expect(double_entry).to have_received(:account).with(:bank, scope: person)
    end

    it 'should transfer from personal bank to seed' do
      allow(double_entry).to receive(:account).with(:seed).and_return(seed)
      allow(double_entry).to receive(:account).with(:bank, scope: person).and_return(bank)

      subject

      expect(double_entry).to have_received(:transfer).with(Money.new(10_00), a_hash_including(
        from: bank,
        to: seed,
        code: :pay_seed
      ))
    end
  end
end

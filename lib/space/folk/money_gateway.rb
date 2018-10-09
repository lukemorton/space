require 'money'

module Space
  module Folk
    class MoneyGateway
      def initialize(double_entry:)
        @double_entry = double_entry
      end

      def initialize_bank(person)
        seed = double_entry.account(:seed)
        bank = double_entry.account(:bank, scope: person)

        double_entry.transfer(
          Money.new(50_00),
          from: seed,
          to: bank,
          code: :initialize
        )
      end

      def bank_balance(person)
        double_entry.account(:bank, scope: person).balance
      end

      def pay_seed(person, amount)
        seed = double_entry.account(:seed)
        bank = double_entry.account(:bank, scope: person)

        double_entry.transfer(
          amount,
          from: bank,
          to: seed,
          code: :pay_seed
        )
      end

      private

      attr_reader :double_entry
    end
  end
end

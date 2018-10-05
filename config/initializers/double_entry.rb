module ActiveRecordScopeFactoryWithClassName
  def initialize(active_record_class)
    @active_record_class = active_record_class
  end

  def scope_identifier
    lambda do |value|
      if value.is_a?(@active_record_class) || value.class.name == @active_record_class.name
        value.id
      else
        super.call(value)
      end
    end
  end
end

DoubleEntry::Account::ActiveRecordScopeFactory.prepend(ActiveRecordScopeFactoryWithClassName)

DoubleEntry.configure do |config|
  config.define_accounts do |accounts|
    person_scope = accounts.active_record_scope_identifier(Space::Folk::Person)
    accounts.define(identifier: :seed)
    accounts.define(identifier: :bank, scope_identifier: person_scope, positive_only: true)
  end

  config.define_transfers do |transfers|
    transfers.define(from: :seed, to: :bank, code: :initialize)
    transfers.define(from: :bank, to: :bank, code: :send)
  end
end

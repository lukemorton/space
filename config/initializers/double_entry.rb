class ActiveRecordScopeFactory
  def initialize(active_record_class)
    @active_record_class = active_record_class
  end

  def scope_identifier
    lambda do |value|
      if value.class.name == @active_record_class.name
        value.id
      else
        fail AccountScopeMismatchError, "Expected instance of `#{@active_record_class}`, received instance of `#{value.class}`"
      end
    end
  end
end


DoubleEntry.configure do |config|
  config.define_accounts do |accounts|
    person_scope = ActiveRecordScopeFactory.new(Space::Folk::Person).scope_identifier
    accounts.define(identifier: :seed)
    accounts.define(identifier: :bank, scope_identifier: person_scope, positive_only: true)
  end

  config.define_transfers do |transfers|
    transfers.define(from: :seed, to: :bank, code: :initialize)
    transfers.define(from: :bank, to: :bank, code: :send)
  end
end

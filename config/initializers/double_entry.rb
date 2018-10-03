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

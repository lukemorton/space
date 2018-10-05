class CurrentPersonPresenter < SimpleDelegator
  def bank_balance
    current_person.bank_balance.format
  end

  def level
    'Lv 100'
  end

  private

  def current_person
    __getobj__
  end
end

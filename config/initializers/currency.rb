curr = {
  priority:            1,
  iso_code:            "USL",
  name:                "United Space Lambda",
  symbol:              "λ",
  subunit:             "Cent",
  subunit_to_unit:     100,
  symbol_first:        true,
  decimal_mark:        ".",
  thousands_separator: ","
}

Money::Currency.register(curr)

Money.default_currency = Money::Currency.new("USL")

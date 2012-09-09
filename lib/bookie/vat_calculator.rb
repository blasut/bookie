class VatCalculator
  def self.calculate(incomes, expenses)
    VatCalculator.new(incomes, expenses).calculate
  end
  
  def initialize(incomes, expenses)
    @incomes = incomes
    @expenses = expenses
  end

  def calculate
    # Get all the entries within the dates
    # Calculate the total vat from the income
    # And subtract the total vat from the expenes
    incomes = total_vat_per_entry_group(@incomes)
    expenses = total_vat_per_entry_group(@expenses)
    incomes - expenses
  end

  private

  def total_vat_per_entry_group(entries)
    entries.map(&:vat).inject(0, &:+)
  end
end

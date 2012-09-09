require 'date'

class Bookie
  TAX_LEVEL = 2

  attr_accessor :entries
  include Comparable

  def initialize
    @entries = []
  end

  def add_entry(entry)
    @entries << entry  
  end

  def total_vat(from=nil, to=nil)
    # Get all the entries within the dates
    # Calculate the total vat from the income
    # And subtract the total vat from the expenes
    incomes = total_vat_per_entry_group(incomes(from, to))
    expenses = total_vat_per_entry_group(expenses(from, to))
    incomes - expenses
  end

  def money_left
    incomes_total = total(incomes)
    expenses_total = total(expenses)
    (incomes_total - expenses_total - total_vat) - (tax_result)
  end

  def tax_result
    total(salaries) * TAX_LEVEL
  end

  def total(entries)
    entries.map(&:money).inject(0, &:+)
  end

  def total_vat_per_entry_group(entries)
    entries.map(&:vat).inject(0, &:+)
  end

  def expenses(from=nil, to=nil)
    @entries.select do |entry|
      if from && to
         entry.expense? && within_range(from, to, entry.date)
      else
        entry.expense?
      end
    end
  end

  def incomes(from=nil, to=nil)
    @entries.select do |entry|
      if from && to
         entry.income? && within_range(from, to, entry.date)
      else
        entry.income?
      end
    end
  end

  def salaries
    @entries.select do |entry|
      entry.salary?
    end
  end

  def within_range(from, to, date)
    datetime = date.to_datetime
    datetime >= from.to_datetime && datetime <= to.to_datetime
  end

end

class Entry
  VAT_LEVEL = 0.2
  attr_reader :date, :money

  def initialize(money, date, type)
    @money = money
    @date = date
    case type
    when :income
      @income = true
    when :expense
      @expense = true
    when :salary
      @salary = true
    end
  end

  def vat
    @money * VAT_LEVEL
  end

  def income?
    @income
  end

  def salary?
    @salary
  end
  
  def expense?
    @expense
  end
end


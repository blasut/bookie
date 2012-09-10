require_relative 'bookie/calculations_helper'
require_relative 'bookie/tax_calculator'
require_relative 'bookie/vat_calculator'
require_relative 'bookie/entry'

class Bookie
  include CalculationsHelper
  attr_accessor :entries

  def initialize
    @entries = []
  end

  def add_entries(entries)
    entries = Array(entries)
    entries.each do |entry|
      @entries << entry
    end
  end

  def total_vat(from=nil, to=nil)
    VatCalculator.calculate(incomes(from, to), expenses(from, to))
  end

  def money_left(from=nil, to=nil)
    incomes_total = total(incomes(from, to))
    expenses_total = total(expenses(from, to))
    (incomes_total - expenses_total - total_vat(from, to)) - (tax_result(from, to))
  end

  def tax_result(from=nil, to=nil)
    TaxCalculator.calculate(salaries(from, to))
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

  def salaries(from=nil, to=nil)
    @entries.select do |entry|
      if from && to
         entry.salary? && within_range(from, to, entry.date)
      else
        entry.salary?
      end
    end
  end
end

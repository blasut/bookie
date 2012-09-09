require 'date'
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

  def money_left
    incomes_total = total(incomes)
    expenses_total = total(expenses)
    (incomes_total - expenses_total - total_vat) - (tax_result)
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

  def within_range(from, to, date)
    datetime = date.to_datetime
    datetime >= from.to_datetime && datetime <= to.to_datetime
  end

end

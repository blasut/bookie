require 'date'
require_relative 'calculations_helper'
require_relative 'tax_calculator'
require_relative 'vat_calculator'

class Bookie
  include CalculationsHelper

  attr_accessor :entries
  include Comparable

  def initialize
    @entries = []
  end

  def add_entry(entry)
    @entries << entry  
  end

  def total_vat(from=nil, to=nil)
    VatCalculator.calculate(incomes(from, to), expenses(from, to))
  end

  def money_left
    incomes_total = total(incomes)
    expenses_total = total(expenses)
    (incomes_total - expenses_total - total_vat) - (tax_result)
  end

  def tax_result
    TaxCalculator.calculate(salaries)
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

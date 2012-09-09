require_relative 'calculations_helper'

class TaxCalculator
  include CalculationsHelper
  TAX_LEVEL = 2

  def self.calculate(salaries)
    TaxCalculator.new(salaries).calculate
  end

  def initialize(salaries)
    @salaries = salaries
  end

  def calculate
    total(@salaries) * TAX_LEVEL
  end
end

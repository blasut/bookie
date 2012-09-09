require_relative 'calculations_helper'

# This system follows the swedish tax system
# Right now, it is a very naive implementation that claims that you have to pay 100% tax on the money you take out.
# This is for the most part correct, even though there are a lot of variables to get a more accurate number

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

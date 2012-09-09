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

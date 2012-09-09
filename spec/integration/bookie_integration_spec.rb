require_relative '../../lib/bookie'

describe Bookie do
  let(:bookie) { Bookie.new }
  let(:income) { Entry.new(5000, Date.new(2012, 01, 9), :income) }
  let(:expense) { Entry.new(500, Date.new(2012, 01, 9), :expense) }
  let(:salary) { Entry.new(100, Date.new(2012, 10, 9), :salary) }

  before :each do
    bookie.add_entries([income, expense, salary])
  end

  describe "saves a record" do
    it "should handle multiple kinds of entries" do
      bookie.salaries.should == [salary]
      bookie.expenses.should == [expense]
      bookie.incomes.should == [income]
    end
  end

  describe "within range" do
    it "should find stuff within a date range" do
      from = Date.new(2012, 01, 9)
      date = Date.new(2012, 02, 5)
      to = Date.new(2012, 03, 9)
      bookie.within_range(from, to, date).should == true
    end
  end

  describe "calculates" do
    let(:income2) { Entry.new(5000, Date.new(2012, 01, 9), :income) }
    let(:expense2) { Entry.new(500, Date.new(2012, 01, 9), :expense) }

    before :each do
      bookie.add_entries([income2, expense2])
    end

    it "the VAT result for the specified monthly period" do
      # 2000 from the income
      # - 200 from the expense
      bookie.total_vat(Date.new(2012, 01, 01), Date.new(2012, 03, 31)).should == 1800 
    end

    it "the tax result for a year" do
      # salary * 2
      # Salary is 100
      bookie.tax_result.should == 200
    end
    
    it "the tax result for a specific period" do
      # salary * 2
      salary = Entry.new(100, Date.new(2012, 04, 10), :salary)
      salary2 = Entry.new(100, Date.new(2012, 06, 30), :salary)
      salary3 = Entry.new(100, Date.new(2012, 07, 25), :salary)
      bookie.add_entries([salary, salary2, salary3])
      # Salary is 300
      bookie.tax_result(Date.new(2012, 04, 01), Date.new(2012, 07, 31)).should == 600
    end

    it "money left after VAT and taxes" do
      # Tax result is the (income + expenses - vat) - salary * 2
      # Income: 10000
      # Expenses: 1000
      # Total after VAT: 7200
      # Minus salary * 2 : 7000
      bookie.money_left.should == 7000
    end

    it "money left after VAT and taxes for a specific period" do
      income = Entry.new(5000, Date.new(2012, 05, 8), :income)
      expense = Entry.new(500, Date.new(2012, 06, 9), :expense) 
      bookie.add_entries([income, expense])
      bookie.money_left(Date.new(2012, 04, 01), Date.new(2012, 07, 31)).should == 3600
    end
  end
end

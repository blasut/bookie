require_relative '../../lib/bookie/calculations_helper'

class DummyClass; end

describe CalculationsHelper do
  before(:each) do 
    @dummy_class = DummyClass.new 
    @dummy_class.extend(CalculationsHelper) 
  end

  it "should calculate the total cost" do
    entries = [stub(:money => 500), stub(:money => 500)]
    @dummy_class.total(entries).should == 1000
  end

  it "should raise raise TypeError if wrong type" do
    entries = [stub(:money => 500), stub.as_null_object]
    expect do
      @dummy_class.total(entries).should == 500
    end.to raise_error(TypeError)
  end

  describe "within range" do
    it "should find stuff within a date range" do
      from = Date.new(2012, 01, 9)
      to = Date.new(2012, 03, 9)
      date = Date.new(2012, 02, 5)
      @dummy_class.within_range(from, to, date).should == true
    end
    
    it "should not find stuff outside of a date range" do
      from = Date.new(2012, 01, 9)
      to = Date.new(2012, 03, 9)
      date = Date.new(2012, 07, 5)
      @dummy_class.within_range(from, to, date).should == false
    end
  end
end

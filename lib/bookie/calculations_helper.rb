module CalculationsHelper
  def total(entries)
    entries.map(&:money).inject(0, &:+)
  end
end

require 'date'

module CalculationsHelper
  def total(entries)
    entries.map(&:money).inject(0, &:+)
  end

  def within_range(from, to, date)
    datetime = date.to_datetime
    datetime >= from.to_datetime && datetime <= to.to_datetime
  end

end

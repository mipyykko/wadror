module Top
  def top(number)
    all.sort_by { |b| -(b.average_rating || 0) }.first(number)
  end
end

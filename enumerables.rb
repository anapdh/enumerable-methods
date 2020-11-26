# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    is_range = !is_a?(Array)
    range = is_range ? self : 0...length
    range.each do |i|
      yield(is_range ? i : self[i])
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    is_range = !is_a?(Array)
    range = is_range ? self : 0...length
    index = 0
    range.each do |i|
      ind = (is_range ? i : self[i])
      yield(ind, index)
      index += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    a = []
    my_each do |n|
      a.push(n) if yield(n)
    end
    a
  end

  def my_all?(pattern = nil)
    my_each do |n|
      unless pattern.nil?
        return false if pattern.is_a?(Class) && !n.is_a?(pattern)
        return false if !pattern.is_a?(Class) && !n.to_s.match(pattern.to_s)
      end
      return false if block_given? && !yield(n)
    end
    return my_all? { |n| n } if !block_given? && pattern.nil?

    true
  end

  def my_any?(pattern = nil)
    my_each do |n|
      unless pattern.nil?
        return true if pattern.is_a?(Class) && n.is_a?(pattern)
        return true if !pattern.is_a?(Class) && n.to_s.match(pattern.to_s)
      end
      return true if block_given? && yield(n)
    end
    return true if !block_given? && pattern.nil? && empty?
    return my_any? { |n| n } if !block_given? && pattern.nil?

    false
  end

  def my_none?(pattern = nil)
    my_each do |n|
      unless pattern.nil?
        return false if pattern.is_a?(Class) && n.is_a?(pattern)
        return false if !pattern.is_a?(Class) && n.to_s.match(pattern.to_s)
      end
      return false if block_given? && yield(n)
    end
    return my_none? { |n| n } if !block_given? && pattern.nil?

    true
  end

  def my_count(arg = nil)
    count = 0
    if arg.nil? && block_given? == false
      my_each do |_n|
        count += 1
      end
    elsif block_given?
      my_each do |n|
        count += 1 if yield(n)
      end
    else
      my_each do |n|
        count += 1 if arg == n
      end
    end
    count
  end

  def my_map(block = nil)
    return to_enum(:my_map) unless block_given? || !block.nil?

    newarr = []
    my_each do |n|
      newarr << if !block.nil?
                  block.call(n)
                else
                  yield(n)
                end
    end
    newarr
  end

  def my_inject(acc = nil, operator = nil)
    if acc.is_a?(Symbol)
      operator = acc
      acc = nil
    end
    is_symbol = operator.is_a?(Symbol)
    raise LocalJumpError if !block_given? && !is_symbol

    is_range = is_a?(Range)
    my_each_with_index do |n, i|
      if (is_range ? true : i.zero?) && acc.nil?
        acc = n
      elsif !operator.nil? && is_symbol
        operator = operator.to_proc
        acc = operator.call(acc, n)
      else
        acc = yield(acc, n)
      end
    end
    acc
  end
end

def multiply_els(arg)
  arg.my_inject do |acc, n|
    acc * n
  end
end

# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity

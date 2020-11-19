module Enumerable
    def my_each
        return to_enum(:my_each) unless block_given?
        is_range = self.kind_of?(Range) 
        range = is_range ? self : 0...self.length
        for i in range do
            yield(is_range ? i : self[i])
        end
    end
    
    def my_each_with_index
        return to_enum(:my_each_with_index) unless block_given?
        is_range = self.kind_of?(Range) 
        range = is_range ? self : 0...self.length
        for i in range do
            yield(is_range ? i : self[i], i)
        end
    end

    def my_select
        return to_enum(:my_select) unless block_given?
        a = []
        my_each do |n|
            if yield(n)
                a.push(n)
            end
        end
        a
    end

    def my_all?(pattern = nil)
        my_each do |n|
            if pattern != nil
                if pattern.kind_of?(Class) && !n.kind_of?(pattern)
                    return false
                end
                if !pattern.kind_of?(Class) && !n.to_s.match(pattern.to_s)
                    return false
                end
            end
            if block_given? && !yield(n)
                return false
            end
        end
        true
    end

    def my_any?(pattern = nil)
        my_each do |n|
            if pattern != nil
                if pattern.kind_of?(Class) && n.kind_of?(pattern)
                    return true
                end
                if !pattern.kind_of?(Class) && n.to_s.match(pattern.to_s)
                    return true
                end
            end
            if block_given? && yield(n)
                return true
            end
        end
        if (!block_given? && pattern == nil && !self.empty?)
            return true
        end
        false
    end

    def my_none?(pattern = nil)
        my_each do |n|
            if pattern != nil
                if pattern.kind_of?(Class) && n.kind_of?(pattern)
                    return false
                end
                if !pattern.kind_of?(Class) && n.to_s.match(pattern.to_s)
                    return false
                end
            end
            if block_given? && yield(n)
                return false
            end
        end
        true
    end

    def my_count(arg = nil)
            count = 0
            if arg == nil && block_given? == false
            return self.length    
            elsif block_given?
                my_each do |n|
                    if yield(n)
                    count += 1
                    end
                end
                return count
            else
            my_each do |n|
                if arg == n
                count += 1
                end
            end
            return count
        end  
    end

    def my_map(&block)
        return to_enum(:my_map) unless block_given?
        newarr = []
        my_each_with_index do | n, i |
            if block == true
            newarr[i] = block.call(n)
            else
            newarr[i] = yield(n)
            end
        end
        return newarr
    end

    def my_inject(acc = nil)
        raise LocalJumpError if !block_given? && acc == nil
        is_range = self.kind_of?(Range)
        my_each_with_index do | n, i |
            if (is_range ? true : i == 0) && acc == nil
              acc = n
            else
              acc = yield(acc, n)
            end
        end
        return acc
    end
end

def multiply_els(arg)
        arg.my_inject do | acc, n |
            acc * n
        end
end

puts '1.--------my_each--------'
%w[Sharon Leo Leila Brian Arun].my_each { |friend| puts friend }

puts '2.--------my_each_with_index--------'
%w[Sharon Leo Leila Brian Arun].my_each_with_index { |friend, index| puts friend if index.even? }

puts '3.--------my_select--------'
puts (%w[Sharon Leo Leila Brian Arun].my_select { |friend| friend != 'Brian' })

puts '4.--------my_all--------'
puts (%w[ant bear cat].my_all? { |word| word.length >= 3 }) #=> true
puts (%w[ant bear cat].my_all? { |word| word.length >= 4 }) #=> false
puts %w[ant bear cat].my_all?(/t/) #=> false
puts [1, 2i, 3.14].my_all?(Numeric) #=> true
puts [].my_all? #=> true

puts '5.--------my_any--------'
puts (%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
puts (%w[ant bear cat].my_any? { |word| word.length >= 4 }) #=> true
puts %w[ant bear cat].my_any?(/d/) #=> false
puts [nil, true, 99].my_any?(Integer) #=> true
puts [nil, true, 99].my_any? #=> true
puts [].my_any? #=> false

puts '6.--------my_none--------'
puts (%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
puts (%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
puts %w[ant bear cat].my_none?(/d/) #=> true
puts [1, 3.14, 42].my_none?(Float) #=> false
puts [].my_none? #=> true
puts [nil].my_none? #=> true
puts [nil, false].my_none? #=> true
puts [nil, false, true].my_none? #=> false

puts '7.--------my_count--------'
arr = [1, 2, 4, 2]
puts arr.my_count #=> 4
puts arr.my_count(2) #=> 2
puts (arr.my_count { |x| (x % 2).zero? }) #=> 3

puts '8.--------my_maps--------'
my_order = ['medium Big Mac', 'medium fries', 'medium milkshake']
puts (my_order.my_map { |item| item.gsub('medium', 'extra large') })
puts ((0..5).my_map { |i| i * i })
puts 'my_map_proc'
my_proc = Proc.new { |i| i * i }
puts (1..5).my_map(&my_proc)

puts '8.--------my_inject--------'
puts ((1..5).my_inject { |sum, n| sum + n }) #=> 15
puts (1..5).my_inject(1) { |product, n| product * n } #=> 120
longest = %w[ant bear cat].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end
puts longest #=> "bear"

puts 'multiply_els'
puts multiply_els([2, 4, 5]) #=> 40


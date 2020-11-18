module Enumerable
    def my_each
        for i in 0...@arr.length do
            yield(@arr[i])
        end
    end
    
    def my_each_with_index
        for i in 0...@arr.length do
            yield(@arr[i], i)
        end
    end

    def my_select
        a = []
        my_each do |n|
            if yield(n)
                a.push(n)
            end
        end
        return a
    end

    def my_all?
        my_each do |n|
            if !yield(n)
                return false
            end
        end
        return true
    end

    def my_none?
        my_each do |n|
            if yield(n)
                return false
            end
        end
        return true
    end

    def my_count(arg = nil)
            count = 0
            if arg == nil && block_given? == false
            return @arr.length    
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

    def my_map
        newarr = []
        my_each_with_index do | n, i |
            newarr[i] = yield(n)
        end
        return newarr
    end

    def my_inject
        acc = nil
        my_each_with_index do | n, i |
            if i == 0
            acc = n
            else
            acc = yield(acc, n)
        end
        end
        return acc
    end
    end

class Arr
    include Enumerable
    def initialize(arr)
        @arr = arr
    end
end

def multiply_els(arg)
    a = Arr.new(arg)
    g = a.my_inject do | acc, n |
        acc * n
    end
    return g
end

a = Arr.new([1, 2, 3])
a.my_each do |n|
    puts "current element #{n}"
end

a.my_each_with_index do |n, i|
    puts "Element at #{i} is #{n}"
end

b = a.my_select do |num|
    num.odd?
end

puts "#{b}"

c = a.my_all? do |n|
    n < 4
end

puts "#{c}"

d = a.my_none? do |n|
    n < 4
end

puts "#{d}"

puts "#{a.my_count}"

puts "#{a.my_count(3)}"

e = a.my_count do |n|
    false
end

puts e

f = a.my_map do | n |
    n + n
end

puts "#{f}"

g = a.my_inject do | acc, n |
    acc * n
end

puts "#{g}"

puts multiply_els([2, 4, 5])
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

end

class Arr
    include Enumerable
    def initialize(arr)
        @arr = arr
    end
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
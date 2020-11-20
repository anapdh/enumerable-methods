module Enumerable
    def my_each
        return to_enum(:my_each) unless block_given?
        is_range = !self.kind_of?(Array) 
        range = is_range ? self : 0...self.length
        for i in range do
            yield(is_range ? i : self[i])
        end
        self
    end
    
    def my_each_with_index
        return to_enum(:my_each_with_index) unless block_given?
        is_range = !self.kind_of?(Array) 
        range = is_range ? self : 0...self.length
        for i in range do
            ind = (is_range ? i : self[i])
            yield(ind, i)
        end
        self
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
        if !block_given? && pattern == nil
            return my_all? {|n| n }
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
        if (!block_given? && pattern == nil && self.empty?)
            return true
        end
        if !block_given? && pattern == nil
            return my_any? {|n| n}
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
        if !block_given? && pattern == nil
            return my_none? {|n| n }
        end
        true
    end

    def my_count(arg = nil)
            count = 0
            if arg == nil && block_given? == false
                my_each do |n|
                    count += 1
                    end
            return count
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
            if block != nil
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

puts [nil].my_any?
puts [].my_any?





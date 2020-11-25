RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

require_relative '../enumerables.rb'
  arr = [1, 2, 3, 5, 5]
  hash = {a: 1, b: 2, c: 3, d: 4}
  range = 0..9
  describe "#my_each" do
    it "Goes through all elements in an Array" do
      i = 0
      arr.my_each { |n| expect(n).to eql(arr[i]); i += 1 }
    end
    it "Goes through all elements in an Hash" do
      hash.my_each { |n| expect(n[1]).to eql(hash[n[0]])}
    end
    it "Goes through all elements in an Range" do
      i = 0
      range.my_each { |n| expect(n).to eql(i); i += 1 }
    end
    it "Returns an Array when self is an Array and a blog is given" do
      result = arr.my_each { |n| n }
      expect(result.kind_of?(Array)).to eql(true)
    end
    it "Returns an Hash when self is an Hash and a blog is given" do
      result = hash.my_each { |n| n }
      expect(result.kind_of?(Hash)).to eql(true)
    end
    it "Returns an Range when self is an Range and a blog is given" do
      result = range.my_each { |n| n }
      expect(result.kind_of?(Range)).to eql(true)
    end
  end

  describe "#my_each_with_index" do
    it "Calls each element of an Array with correct Index" do
      arr.my_each_with_index do |n, i| 
        expect(n).to eql(arr[i])
      end
    end
    it "Calls each element of an Hash with correct Index" do
      i = 0
      hash.my_each_with_index do |n, j| 
        expect(n[1]).to eql(hash[n[0]])
        expect(j).to eql(i)
        i += 1
      end
    end
    it "Calls each element of an Range with correct Index" do
      i = 0
      range.my_each_with_index do |n, j|
        expect(n).to eql(i)
        expect(j).to eql(i)
        i += 1
      end
    end
    it "Returns an Array when self is an Array and a blog is given" do
      result = arr.my_each_with_index { |n, j| n }
      expect(result.kind_of?(Array)).to eql(true)
    end
    it "Returns an Hash when self is an Hash and a blog is given" do
      result = hash.my_each_with_index { |n, j| n }
      expect(result.kind_of?(Hash)).to eql(true)
    end
    it "Returns an Range when self is an Range and a blog is given" do
      result = range.my_each_with_index { |n, j| n }
      expect(result.kind_of?(Range)).to eql(true)
    end
  end
# puts '2.--------my_each_with_index--------'
# %w[Sharon Leo Leila Brian Arun].my_each_with_index { |friend, index| puts friend if index.even? }

# puts '3.--------my_select--------'
# puts (%w[Sharon Leo Leila Brian Arun].my_select { |friend| friend != 'Brian' })

# puts '4.--------my_all--------'
# puts (%w[ant bear cat].my_all? { |word| word.length >= 3 }) #=> true
# puts (%w[ant bear cat].my_all? { |word| word.length >= 4 }) #=> false
# puts %w[ant bear cat].my_all?(/t/) #=> false
# puts [1, 2i, 3.14].my_all?(Numeric) #=> true
# puts [].my_all? #=> true

# puts '5.--------my_any--------'
# puts (%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
# puts (%w[ant bear cat].my_any? { |word| word.length >= 4 }) #=> true
# puts %w[ant bear cat].my_any?(/d/) #=> false
# puts [nil, true, 99].my_any?(Integer) #=> true
# puts [nil, true, 99].my_any? #=> true
# puts [].my_any? #=> false

# puts '6.--------my_none--------'
# puts (%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
# puts (%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
# puts %w[ant bear cat].my_none?(/d/) #=> true
# puts [1, 3.14, 42].my_none?(Float) #=> false
# puts [].my_none? #=> true
# puts [nil].my_none? #=> true
# puts [nil, false].my_none? #=> true
# puts [nil, false, true].my_none? #=> false

# puts '7.--------my_count--------'
# arr = [1, 2, 4, 2]
# puts arr.my_count #=> 4
# puts arr.my_count(2) #=> 2
# puts (arr.my_count { |x| (x % 2).zero? }) #=> 3

# puts '8.--------my_maps--------'
# my_order = ['medium Big Mac', 'medium fries', 'medium milkshake']
# puts (my_order.my_map { |item| item.gsub('medium', 'extra large') })
# puts ((0..5).my_map { |i| i * i })
# puts 'my_map_proc'
# my_proc = proc { |i| i * i }
# puts (1..5).my_map(&my_proc)

# puts '8.--------my_inject--------'
# puts ((1..5).my_inject { |sum, n| sum + n }) #=> 15
# puts (1..5).my_inject(1) { |product, n| product * n } #=> 120
# longest = %w[ant bear cat].my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end
# puts longest #=> "bear"

# puts 'multiply_els'
# puts multiply_els([2, 4, 5]) #=> 40


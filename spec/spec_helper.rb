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

  describe "my_select" do
    it "Successfully select elements of self" do 
      result = arr.my_select {|n| n.even? }
      expect(result).to eql([2])
    end
    it "Returns an Array when self is an Array" do 
      result = arr.my_select {|n| n }
      expect(result.kind_of?(Array)).to eql(true)
    end
    it "Returns an Array when self is an Hash" do 
      result = hash.my_select {|n| n }
      expect(result.kind_of?(Array)).to eql(true)
    end
    it "Returns an Array when self is an Range" do 
      result = range.my_select {|n| n }
      expect(result.kind_of?(Array)).to eql(true)
    end
  end

  describe "#my_all?" do
    it "Works when all the cases are true" do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
    end
    it "Works when just 1 element is true" do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 4 }).to eql(false)
    end
    it "Works when a Regex argument is given" do
      expect(%w[ant bear cat].my_all?(/t/)).to eql(false)
    end
    it "Works when a type argument is given" do
      expect([1, 2i, 3.14].my_all?(Numeric)).to eql(true)
    end
    it "Works when no argument nor block is given" do
      expect([].my_all?).to eql(true)
    end
  end

  describe "#my_any?" do
    it "Works when all the cases are true" do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 3 }).to eql true
    end
    it "Works when one the cases are true" do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 4 }).to eql true
    end
    it "Works when a Regex argument is given" do
      expect(%w[ant bear cat].my_any?(/d/)).to eql false
    end
    it "Works when a type argument is given" do
      expect([nil, true, 99].my_any?(Integer)).to eql true
    end
    it "Works when no argument nor block is given" do 
      expect([nil, true, 99].my_any? eql true).to eql false
    end
    it "Works when self is empty" do
      expect([].my_any?).to eql true
    end
  end

  describe "#my_none" do
    it "Works when all the cases are false" do
      expect(%w[ant bear cat].my_none? { |word| word.length == 5 }).to eql true
    end
    it "Works when one the cases are true" do
      expect(%w[ant bear cat].my_none? { |word| word.length >= 4 }).to eql false  
    end
    it "Works when a Regex is given as an argument" do
      expect(%w[ant bear cat].my_none?(/d/)).to eql true
    end
    it "Works when a type is given as an argument" do
      expect([1, 3.14, 42].my_none?(Float)).to eql false
    end
    it "Works when no argument nor block is given and self is empty" do
      expect([].my_none?).to eql true
    end
    it "Works when no argument nor block is given and elements are nil" do
      expect([nil].my_none?).to eql true
    end
    it "Works when no argument nor block is given and elements are nil or false" do
      expect([nil, false].my_none?).to eql true
    end
    it "Works when no argument nor block is given and one of the elements is true" do
      expect([nil, false, true].my_none?).to eql(false)
    end
  
  end

  describe "#my_count" do
    it "Successfully count the elements of an Array" do 
      expect(arr.my_count).to eql(5)
    end
    it "Successfully count the elements of an Array when an argument is given" do 
      expect(arr.my_count(2)).to eql 1
    end
    it "Successfully count the elements of an Array when a block is given" do 
      expect(arr.my_count { |x| x.odd? }).to eql 4
    end
  
  end

  describe "#my_map" do
    it "Returns an Array with the new elements when self is an an Array" do 
      result = (arr.my_map { |i| i * 2 })
      expect(result.kind_of?(Array)).to eql true
      expect(result).to eql([2, 4, 6, 10, 10])
    end
    
    it "Returns an Array with the new elements when self is an a Range" do 
      result = ((0..5).my_map { |i| i * 2 })
      expect(result.kind_of?(Array)).to eql true
      expect(result).to eql([0, 2, 4, 6, 8, 10])
    end

    it "Takes the Proc when a Proc and a Block are given" do 
      my_proc = proc { |i| i * i }
      result = ((0..5).my_map(my_proc) { |i| i * 2 })
      expect(result.kind_of?(Array)).to eql true
      expect(result).to eql([0, 1, 4, 9, 16, 25])
    end
    
  end 
  
  describe "#my_inject" do
    it "Works when a block is given" do
      expect((1..5).my_inject { |sum, n| sum + n }).to eql 15
    end
    it "Works when a block and an Argument are given" do
      expect((1..5).my_inject(1) { |product, n| product * n }).to eql 120
    end
    it "Works when a a symbol is given and no block is given" do
      expect((1..5).my_inject(1, :*)).to eql 120
    end
  end


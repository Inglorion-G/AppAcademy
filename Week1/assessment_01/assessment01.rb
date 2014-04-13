def is_prime?(num)
  (2...num).none? { |factor| num % factor == 0 }
end

def primes(num)
  primes = []
  i = 2
  until primes.length >= num
    primes << i if is_prime?(i)
    i += 1
  end
  primes
end

def factorials_rec(num)
  return [1] if num == 1
  facs = factorials_rec(num - 1)
  facs << facs.last * num
end

class Array
  
  # def dups
#     
#     dups = {}
#     
#     self.each_index do |idx1|
#       (idx1 + 1).upto(self.length - 1) do |idx2|
#         if self[idx1] == self[idx2]
#           if !dups.has_key?(self[idx1])
#             dups[self[idx1]] = [idx1, idx2]
#           elsif dups.has_key?(self[idx1]) && dups[self[idx1]].include?(idx2)
#             nil
#           elsif dups.has_key?(self[idx1]) && !dups[self[idx1]].include?(idx2)
#             dups[self[idx1]] << idx2
#           end
#         end
#       end
#     end
#     dups
#  end

  def dups
  
    dups = {}
  
    self.each_index do |i1|
      (i1 + 1).upto(self.length - 1) do |i2|
        el1 = self[i1]
        el2 = self[i2]
        if el1 == el2 && (dups.has_key?(el1) == false)
          dups[el1] = [i1, i2]
        elsif el1 == el2 && dups.has_key?(el1) == true
          if dups[el1].include?(i2)
            nil
          else
            dups[el1] << i2
          end
        end
      end
    end
    dups
  end
  
  def bubble_sort(&blk)
    blk = Proc.new { |x,y| x <=> y } unless blk
    new_arr = self.dup
    sorted = false
    
    until sorted
      sorted = true
      new_arr.each_index do |i1|
        (i1...new_arr.length).each do |i2|
          if blk.call(new_arr[i1], new_arr[i2]) == 1
            new_arr[i1], new_arr[i2] = new_arr[i2], new_arr[i1]
            sorted = false
          end
        end
      end
    end
    new_arr
  end
  
end

class String
  
  def symmetric_substrings
    substrings = []
    (0...self.length).each do |char1|
      (char1).upto(self.length).each do |char2|
        test = self[char1..char2]
        if test.length > 1 && test.reverse == test
          substrings << test
        else
          next
        end
      end
    end
    substrings.uniq
  end  
end
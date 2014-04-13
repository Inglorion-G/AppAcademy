def range(start_val, end_val)
  if start_val == end_val
    return [end_val]

  else
    range(start_val + 1, end_val).unshift start_val
  end
end


# iteration version
def sum_array(array)
  array.inject(0){|x,y| x + y}
end

# recursive version
def sum_array(array)
  return array[0] if array.length == 1
  array[0] + sum_array(array[1..-1])
end

# first version
def exponent(num, exp)
  return 1 if exp == 0
  num * exponent(num, exp - 1)
end

# second version
def exponent(num, exp)
  return num if exp == 1
  return exponent(num, exp / 2) ** 2 if num % 2 == 0
  num * (exponent(num, (exp - 1) / 2) ** 2 )
end

class Array

  def deep_dup
    duplicate_array = []
    unless self.any? { |element| element.is_a?(Array) }
      self.each do |x|
        # shovel mutates the duplicate array rather than
        # retaining a reference to self with +=
        duplicate_array << x
      end
      return duplicate_array
    end

    self.each do |sub_arr|
      duplicate_array << sub_arr.deep_dup
    end
    duplicate_array
  end

end

def iterative_fib_nums(n)
  fib = [0, 1]
  n = n-1
  return "No fibs" if n == -1
  if n < 2
    return fib[n]
  else
    n.times do
      fib << fib[-1] + fib[-2]
    end
  end
  fib
end

def fib_nums(n)
  return [0, 1] if n == 2
  temp_array = fib_nums(n-1)
  temp_array << temp_array[-2] + temp_array[-1]
  temp_array
end

def binary_search(array, target)
  if array.empty?
    return nil
  end

  midpoint = array.length / 2

  if target < array[midpoint]
    binary_search(array[0...midpoint], target)
  elsif target == array[midpoint]
    midpoint
  else
    midpoint + binary_search(array[midpoint..-1], target)
  end
end

def make_change(value, currency)
  return [currency.last] if value == 1
  return [] if value == 0
  best_combo = []
  currency.each_with_index do |coin, i|
    return [coin] if coin == value
    next if i == currency.length - 1
    if value > coin && ((value - coin) > currency[i + 1])
      combination = make_change(value - coin, currency) << coin
      best_combo = combination if best_combo.empty? || combination.length < best_combo.length
    end
  end
  best_combo
end


def merge_sort(array)
  return array if array.length == 1
  sub_arr1 = merge_sort(array[0...(array.length / 2)])
  sub_arr2 = merge_sort(array[(array.length/2)..-1])

  merge_helper(sub_arr1, sub_arr2)
end

def merge_helper(sub_arr1, sub_arr2)
  merge_arr = []
  until sub_arr1.empty? || sub_arr2.empty?
    if sub_arr1[0] > sub_arr2[0]
      merge_arr << sub_arr2.shift
    else
      merge_arr << sub_arr1.shift
    end
  end
  merge_arr + sub_arr1 + sub_arr2
end

def subsets(array)
  return [[]] if array.empty?
  temp_sets = subsets(array[0...-1])
  temp_sets + temp_sets.map {|set| set + [array.last]}
end
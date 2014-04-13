class Array
  def my_each(&prc)
    count = 0
    while count < self.length
      prc.call self[count]
      count += 1
    end
  end

  def my_map(&prc)
    temp = []
    self.my_each { |x| temp << prc.call(x) }
    temp
  end

  def my_select(&prc)
    temp = []
    self.my_each { |x| temp << x if prc.call(x)}
    temp
  end

  def my_inject(&prc)
    total = self[0]
    self.my_each do |array_object|
      next if self.index(array_object) == 0
      total = prc.call(total,array_object)
    end
    total
  end

  def my_sort!(&prc)
    sorted = false
    until sorted
      sorted = true
      (0...self.length - 1).each do |idx|
        if prc.call(self[idx], self[idx + 1]) > 0
          sorted = false
          self[idx], self[idx + 1] = self[idx + 1], self[idx]
        end
      end
    end
    self
  end

end


#[1,2,3].my_each {|x| puts x}
#puts [1,3,6].my_map {|x| x * 2}
#puts [1,3,6].my_select { |x| x % 2 == 0}
#puts [1,3,6].my_inject { |x,y| x + y}

# cool_nums_array = [5, 3, 1, 8, 4]
#
# cool_nums_array.my_sort! { |num1, num2| num1 <=> num2 }
# print cool_nums_array

def eval_block(*args, &prc)

  if prc.nil?
    print "NO BLOCK GIVEN!"
    return nil
  end

  args.each do |arg|
    prc.call(arg)
  end

end

eval_block(1,2,3) { |num| puts num }































# ============================================
# LAB 3: Strategy Pattern
# ============================================
# The Strategy pattern defines a family of algorithms, encapsulates each one,
# and makes them interchangeable. Strategy lets the algorithm vary independently
# from clients that use it.
# Run this file with: ruby strategy.rb

# Exercise 1: Payment Strategy
# Implement different payment methods that can be used interchangeably
class PaymentStrategy
  def pay(amount)
    raise NotImplementedError, "Subclasses must implement pay method"
  end
end

class CreditCardPayment < PaymentStrategy
  def initialize(card_number)
    @card_number = card_number
  end
  
  # TODO: Implement pay method
  # Return "Paid $#{amount} using Credit Card ending in #{last_4_digits}"
  def pay(amount)
    return "Paid $#{amount} using Credit Card ending in #{last_4_digits}"
  end
  
  private
  
  def last_4_digits
    @card_number[-4..-1]
  end
end

class PayPalPayment < PaymentStrategy
  def initialize(email)
    @email = email
  end
  
  # TODO: Implement pay method
  # Return "Paid $#{amount} using PayPal account #{email}"
  def pay(amount)
    return "Paid $#{amount} using PayPal account #{@email}"
  end
end

class CryptoPayment < PaymentStrategy
  def initialize(wallet_address)
    @wallet_address = wallet_address
  end
  
  # TODO: Implement pay method
  # Return "Paid $#{amount} using Crypto wallet #{wallet_address}"
  def pay(amount)
    return "Paid $#{amount} using Crypto wallet #{@wallet_address}"
  end
end

class ShoppingCart
  def initialize
    @items = []
    @payment_strategy = nil
  end
  
  def add_item(name, price)
    @items << { name: name, price: price }
  end
  
  # TODO: Implement set_payment_strategy method
  def set_payment_strategy(strategy)
    @payment_strategy = strategy
  end
  
  def total
    @items.sum { |item| item[:price] }
  end
  
  # TODO: Implement checkout method
  # Use the payment strategy to process payment
  # Return the result from payment strategy's pay method
  def checkout
    return @payment_strategy.pay(total)
  end
end

# Exercise 2: Sorting Strategy
# Implement different sorting algorithms as strategies

module SortStrategy
  def sort(array)
    raise NotImplementedError
  end
end

class BubbleSort
  include SortStrategy
  
  # TODO: Implement bubble sort
  # Return sorted array (ascending order)
  def sort(array)
    arr = Array.new(array)
    n = array.length
    (0...n).each do |i|
      (0...(n - i - 1)).each do |j|
        if (arr[j] > arr[j + 1])
          temp = arr[j]
          arr[j] = arr[j + 1]
          arr[j + 1] = temp
        end
      end
    end
    arr
  end
end
class QuickSort
  include SortStrategy
  
  # TODO: Implement quick sort or use Ruby's built-in sort
  # Return sorted array (ascending order)
  def sort(array)
    return array if array.length <= 1

    pivot = array.delete_at(rand(array.length))
    left, right = array.partition { |x| x < pivot }

    return [*sort(left), pivot, *sort(right)]
  end
end

class ReverseSort
  include SortStrategy
  
  # TODO: Implement reverse sort
  # Return sorted array (descending order)
  def sort(array)
    return array.sort.reverse
  end
end

class DataProcessor
  def initialize(sort_strategy)
    @sort_strategy = sort_strategy
  end
  
  # TODO: Implement set_strategy method
  def set_strategy(strategy)
    @sort_strategy = strategy
  end
  
  # TODO: Implement process method
  # Use the sort strategy to sort the data
  def process(data)
    @sort_strategy.sort(data)
  end
end

# Exercise 3: Compression Strategy
# Implement different compression algorithms

class CompressionStrategy
  def compress(data)
    raise NotImplementedError
  end
end

class ZipCompression < CompressionStrategy
  def compress(data)
    "ZIP compressed: #{data}"
  end
end

class RarCompression < CompressionStrategy
  def compress(data)
    "RAR compressed: #{data}"
  end
end
class NoCompression < CompressionStrategy
  # TODO: Implement compress method
  # Return "Not compressed: #{data}"
  def compress(data)
    return "Not compressed: #{data}"
  end
end

class FileHandler
  attr_reader :compression_strategy
  
  def initialize(compression_strategy = NoCompression.new)
    @compression_strategy = compression_strategy
  end
  
  # TODO: Implement set_compression method
  def set_compression(strategy)
    @compression_strategy = strategy
  end
  
  # TODO: Implement save_file method
  # Compress data using the strategy and return result
  def save_file(data)
    @compression_strategy.compress(data)
  end
end

processor = DataProcessor.new(BubbleSort.new)
result = processor.process([3, 1, 4, 1, 5, 9, 2, 6])
puts result
# ============================================
# TEST CASES - Do not modify below this line
# ============================================

def run_tests
  tests_passed = 0
  total_tests = 0
  
  puts "Testing Strategy Pattern..."
  puts "=" * 40
  
  # Test 1: Credit Card Payment
  total_tests += 1
  begin
    cart = ShoppingCart.new
    cart.add_item("Book", 10)
    cart.add_item("Pen", 5)
    cart.set_payment_strategy(CreditCardPayment.new("1234567890123456"))
    result = cart.checkout
    
    if result.include?("15") && result.include?("3456")
      tests_passed += 1
      puts "✓ Test 1 passed: Credit Card payment works"
    else
      puts "✗ Test 1 failed: Credit Card payment incorrect"
    end
  rescue => e
    puts "✗ Test 1 failed: #{e.message}"
  end
  
  # Test 2: PayPal Payment
  total_tests += 1
  begin
    cart = ShoppingCart.new
    cart.add_item("Mouse", 25)
    cart.set_payment_strategy(PayPalPayment.new("user@example.com"))
    result = cart.checkout
    
    if result.include?("25") && result.include?("user@example.com")
      tests_passed += 1
      puts "✓ Test 2 passed: PayPal payment works"
    else
      puts "✗ Test 2 failed: PayPal payment incorrect"
    end
  rescue => e
    puts "✗ Test 2 failed: #{e.message}"
  end
  
  # Test 3: Crypto Payment
  total_tests += 1
  begin
    cart = ShoppingCart.new
    cart.add_item("Keyboard", 50)
    cart.set_payment_strategy(CryptoPayment.new("0x1234abcd"))
    result = cart.checkout
    
    if result.include?("50") && result.include?("0x1234abcd")
      tests_passed += 1
      puts "✓ Test 3 passed: Crypto payment works"
    else
      puts "✗ Test 3 failed: Crypto payment incorrect"
    end
  rescue => e
    puts "✗ Test 3 failed: #{e.message}"
  end
  
  # Test 4: Bubble Sort
  total_tests += 1
  begin
    processor = DataProcessor.new(BubbleSort.new)
    result = processor.process([3, 1, 4, 1, 5, 9, 2, 6])
    
    if result == [1, 1, 2, 3, 4, 5, 6, 9]
      tests_passed += 1
      puts "✓ Test 4 passed: Bubble sort works"
    else
      puts "✗ Test 4 failed: Bubble sort incorrect"
    end
  rescue => e
    puts "✗ Test 4 failed: #{e.message}"
  end
  
  # Test 5: Quick Sort
  total_tests += 1
  begin
    processor = DataProcessor.new(QuickSort.new)
    result = processor.process([5, 2, 8, 1, 9])
    
    if result == [1, 2, 5, 8, 9]
      tests_passed += 1
      puts "✓ Test 5 passed: Quick sort works"
    else
      puts "✗ Test 5 failed: Quick sort incorrect"
    end
  rescue => e
    puts "✗ Test 5 failed: #{e.message}"
  end
  
  # Test 6: Reverse Sort
  total_tests += 1
  begin
    processor = DataProcessor.new(ReverseSort.new)
    result = processor.process([3, 1, 4, 1, 5])
    
    if result == [5, 4, 3, 1, 1]
      tests_passed += 1
      puts "✓ Test 6 passed: Reverse sort works"
    else
      puts "✗ Test 6 failed: Reverse sort incorrect"
    end
  rescue => e
    puts "✗ Test 6 failed: #{e.message}"
  end
  
  # Test 7: Change sorting strategy
  total_tests += 1
  begin
    processor = DataProcessor.new(BubbleSort.new)
    processor.set_strategy(ReverseSort.new)
    result = processor.process([1, 2, 3])
    
    if result == [3, 2, 1]
      tests_passed += 1
      puts "✓ Test 7 passed: Strategy change works"
    else
      puts "✗ Test 7 failed: Strategy change incorrect"
    end
  rescue => e
    puts "✗ Test 7 failed: #{e.message}"
  end
  
  # Test 8: ZIP Compression
  total_tests += 1
  begin
    handler = FileHandler.new
    handler.set_compression(ZipCompression.new)
    result = handler.save_file("test data")
    
    if result == "ZIP compressed: test data"
      tests_passed += 1
      puts "✓ Test 8 passed: ZIP compression works"
    else
      puts "✗ Test 8 failed: ZIP compression incorrect"
    end
  rescue => e
    puts "✗ Test 8 failed: #{e.message}"
  end
  
  # Test 9: RAR Compression
  total_tests += 1
  begin
    handler = FileHandler.new(RarCompression.new)
    result = handler.save_file("important file")
    
    if result == "RAR compressed: important file"
      tests_passed += 1
      puts "✓ Test 9 passed: RAR compression works"
    else
      puts "✗ Test 9 failed: RAR compression incorrect"
    end
  rescue => e
    puts "✗ Test 9 failed: #{e.message}"
  end
  
  # Test 10: No Compression
  total_tests += 1
  begin
    handler = FileHandler.new(NoCompression.new)
    result = handler.save_file("plain text")
    
    if result == "Not compressed: plain text"
      tests_passed += 1
      puts "✓ Test 10 passed: No compression works"
    else
      puts "✗ Test 10 failed: No compression incorrect"
    end
  rescue => e
    puts "✗ Test 10 failed: #{e.message}"
  end
  
  puts "\n" + "=" * 40
  if tests_passed == total_tests
    puts "🎉 All tests passed! (#{tests_passed}/#{total_tests})"
    puts "Fantastic! You've mastered the Strategy pattern!"
  else
    puts "Tests passed: #{tests_passed}/#{total_tests}"
    puts "Keep working on the remaining exercises."
  end
  puts "=" * 40
end

# Run the tests
run_tests

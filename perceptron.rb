require 'csv'

class Perceptron
  attr_accessor :weights, :learning_rate, :threshold

  def initialize dimensions, learning_rate, threshold
    @weights = [0]*dimensions  # initialize with array of size "dimensions"
    @learning_rate = learning_rate # learning rate on the learn algorithm
    @threshold = threshold # threshold for output
  end

  # Public: train the perceptron updating its weights. Will not stop until
  # the perceptron have 100% accuracy producing the correct output
  #
  # training_set: array of hashes describing the training set to be used on
  # the training. Sample:
  # [{input: [0,0], output: 1}, {input: [0,1], output: 1}]
  #
  def learn training_set, limit = 200
    count = 0
    # until there is no errors for the training_set
    until( self.test(training_set) == 0 || count >= limit ) do
      # for each training_example on the training_set
      training_set.each do |training_example|
        # calculate the perceptron output for the training_example
        actual_output = self.output(training_example[:input])
        # get the desired output from the training_example
        desired_output = training_example[:output]


        # update the weights of the perceptron
        @weights = @weights.zip(training_example[:input]).map do |array|
          # w + alpha(d[j] - y[j])
          weight = array[0]
          input = array[1]
          weight + learning_rate*(desired_output - actual_output)*input
        end
      end
      count += 1

      # count the errors and output info
      errors_found = self.test(training_set)
      puts "training iteration # #{count}, errors found: #{errors_found}"
    end
  end

  # Public: test the perceptron with a set of inputs and desired outputs.
  #
  # test_set: array of hashes describing the test set to be used on
  # the test. Sample:
  # [{input: [0,0], output: 1}, {input: [0,1], output: 1}]
  #
  # Returns the count for the number of errors encountered
  #
  def test test_set
    test_set.inject(0) do |errors, test_example|
        if self.output(test_example[:input]) != test_example[:output]
          errors + 1
        else
          errors
        end
    end
  end

  # Public: just return the output for the perceptron for a given input
  #
  # input: array of numbers describing the input. Must match the number of
  # dimensions initialized on the perceptron. Sample for 2 dimensions: [0,1]
  #
  # Returns either 0 or 1
  #
  def output(input)
    result = input.zip(weights).inject(0) do |result, temp_array|
      result + temp_array[0] * temp_array[1]
    end
    (result > threshold)? 1 : 0
  end
end

# Training set for logic AND
and_training_set = [
{ input: [0,0,0,0], output: 0 },
{ input: [0,0,0,1], output: 0 },
{ input: [0,0,1,0], output: 0 },
{ input: [0,0,1,1], output: 0 },
{ input: [0,1,0,0], output: 0 },
{ input: [0,1,0,1], output: 0 },
{ input: [0,1,1,0], output: 0 },
{ input: [0,1,1,1], output: 0 },
{ input: [1,0,0,0], output: 0 },
{ input: [1,0,0,1], output: 0 },
{ input: [1,0,1,0], output: 0 },
{ input: [1,0,1,1], output: 0 },
{ input: [1,1,0,0], output: 0 },
{ input: [1,1,0,1], output: 0 },
{ input: [1,1,1,0], output: 0 },
{ input: [1,1,1,1], output: 1 }
]

# Training set for logic OR
or_training_set = [
{ input: [0,0,0,0], output: 0 },
{ input: [0,0,0,1], output: 1 },
{ input: [0,0,1,0], output: 1 },
{ input: [0,0,1,1], output: 1 },
{ input: [0,1,0,0], output: 1 },
{ input: [0,1,0,1], output: 1 },
{ input: [0,1,1,0], output: 1 },
{ input: [0,1,1,1], output: 1 },
{ input: [1,0,0,0], output: 1 },
{ input: [1,0,0,1], output: 1 },
{ input: [1,0,1,0], output: 1 },
{ input: [1,0,1,1], output: 1 },
{ input: [1,1,0,0], output: 1 },
{ input: [1,1,0,1], output: 1 },
{ input: [1,1,1,0], output: 1 },
{ input: [1,1,1,1], output: 1 }
]

# Training set for logic XOR
xor_training_set = [
{ input: [0,0,0,0], output: 0 },
{ input: [0,0,0,1], output: 1 },
{ input: [0,0,1,0], output: 1 },
{ input: [0,0,1,1], output: 0 },
{ input: [0,1,0,0], output: 1 },
{ input: [0,1,0,1], output: 0 },
{ input: [0,1,1,0], output: 0 },
{ input: [0,1,1,1], output: 0 },
{ input: [1,0,0,0], output: 1 },
{ input: [1,0,0,1], output: 0 },
{ input: [1,0,1,0], output: 0 },
{ input: [1,0,1,1], output: 0 },
{ input: [1,1,0,0], output: 0 },
{ input: [1,1,0,1], output: 0 },
{ input: [1,1,1,0], output: 0 },
{ input: [1,1,1,1], output: 0 }
]
# Perceptron, 2 dimensions, 0.1 of learning rate, 0.5 for output threshold
p = Perceptron.new(4, 0.05, 0.5)

puts "Training perceptron for logic AND\n"

p.learn(and_training_set)

puts "\n"

puts "output for [0,0,0,0]: #{p.output([0,0,0,0])}"
puts "output for [0,0,0,1]: #{p.output([0,0,0,1])}"
puts "output for [0,0,1,0]: #{p.output([0,0,1,0])}"
puts "output for [0,0,1,1]: #{p.output([0,0,1,1])}"
puts "output for [0,1,0,0]: #{p.output([0,1,0,0])}"
puts "output for [0,1,0,1]: #{p.output([0,1,0,1])}"
puts "output for [0,1,1,0]: #{p.output([0,1,1,0])}"
puts "output for [0,1,1,1]: #{p.output([0,1,1,1])}"
puts "output for [1,0,0,0]: #{p.output([1,0,0,0])}"
puts "output for [1,0,0,1]: #{p.output([1,0,0,1])}"
puts "output for [1,0,1,0]: #{p.output([1,0,1,0])}"
puts "output for [1,0,1,1]: #{p.output([1,0,1,1])}"
puts "output for [1,1,0,0]: #{p.output([1,1,0,0])}"
puts "output for [1,1,0,1]: #{p.output([1,1,0,1])}"
puts "output for [1,1,1,0]: #{p.output([1,1,1,0])}"
puts "output for [1,1,1,1]: #{p.output([1,1,1,1])}"

puts "\n\nTraining perceptron for logic OR\n"

p.learn(or_training_set)

puts "\n"

puts "output for [0,0,0,0]: #{p.output([0,0,0,0])}"
puts "output for [0,0,0,1]: #{p.output([0,0,0,1])}"
puts "output for [0,0,1,0]: #{p.output([0,0,1,0])}"
puts "output for [0,0,1,1]: #{p.output([0,0,1,1])}"
puts "output for [0,1,0,0]: #{p.output([0,1,0,0])}"
puts "output for [0,1,0,1]: #{p.output([0,1,0,1])}"
puts "output for [0,1,1,0]: #{p.output([0,1,1,0])}"
puts "output for [0,1,1,1]: #{p.output([0,1,1,1])}"
puts "output for [1,0,0,0]: #{p.output([1,0,0,0])}"
puts "output for [1,0,0,1]: #{p.output([1,0,0,1])}"
puts "output for [1,0,1,0]: #{p.output([1,0,1,0])}"
puts "output for [1,0,1,1]: #{p.output([1,0,1,1])}"
puts "output for [1,1,0,0]: #{p.output([1,1,0,0])}"
puts "output for [1,1,0,1]: #{p.output([1,1,0,1])}"
puts "output for [1,1,1,0]: #{p.output([1,1,1,0])}"
puts "output for [1,1,1,1]: #{p.output([1,1,1,1])}"

puts "\n\nTraining perceptron for logic XOR\n"

p.learn(xor_training_set)

puts "\n"

puts "output for [0,0,0,0]: #{p.output([0,0,0,0])}"
puts "output for [0,0,0,1]: #{p.output([0,0,0,1])}"
puts "output for [0,0,1,0]: #{p.output([0,0,1,0])}"
puts "output for [0,0,1,1]: #{p.output([0,0,1,1])}"
puts "output for [0,1,0,0]: #{p.output([0,1,0,0])}"
puts "output for [0,1,0,1]: #{p.output([0,1,0,1])}"
puts "output for [0,1,1,0]: #{p.output([0,1,1,0])}"
puts "output for [0,1,1,1]: #{p.output([0,1,1,1])}"
puts "output for [1,0,0,0]: #{p.output([1,0,0,0])}"
puts "output for [1,0,0,1]: #{p.output([1,0,0,1])}"
puts "output for [1,0,1,0]: #{p.output([1,0,1,0])}"
puts "output for [1,0,1,1]: #{p.output([1,0,1,1])}"
puts "output for [1,1,0,0]: #{p.output([1,1,0,0])}"
puts "output for [1,1,0,1]: #{p.output([1,1,0,1])}"
puts "output for [1,1,1,0]: #{p.output([1,1,1,0])}"
puts "output for [1,1,1,1]: #{p.output([1,1,1,1])}"
#
# puts "output for [0, 0]: #{p.output([0,0])}"
# puts "output for [1, 0]: #{p.output([1,0])}"
# puts "output for [0, 1]: #{p.output([0,1])}"
# puts "output for [1, 1]: #{p.output([1,1])}"

class ComputerPlayer
  def initialize
    @letters_guessed = []
    @letters_unguessed = {}
    @correct_guesses = []
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
  end

  def render_hidden_word
    @secret_word.split(//).map do |letter|
      @correct_guesses.include?(letter) ? letter : "_"
    end.join
  end

  def receive_secret_length(hidden_word_length)
    reduce_dictionary_by_length(hidden_word_length)
    @letters_unguessed = create_letter_frequency_hash
  end

  def create_letter_frequency_hash
    Hash.new(0).tap do |hash|
      @dictionary.each do |word|
        letters = word.split(//) - @letters_guessed
        letters.each { |letter| hash[letter] += 1 }
      end
    end.sort_by { |k, v| v }.reverse
  end

  def reduce_dictionary_by_length(length)
    @dictionary.select! { |word| word.length == length }
  end

  def check_guess(guess)
    if @secret_word.split(//).include?(guess)
      @correct_guesses << guess
    end
    true
  end

  def display_endgame_message
    puts "Congratulations, you win!"
  end

  def guess
    @letters_unguessed[0][0]
  end

  def handle_guess_response(response)
    hidden_word = response.last

    letter_guessed = @letters_unguessed[0][0]
    @letters_guessed << letter_guessed
    @letters_unguessed.shift

    p @dictionary.size

    if response.first
      @dictionary.select! { |word| word.split(//).include?(letter_guessed[0]) }
      #filter_unguessed_words(hidden_word)
    else
      @dictionary.select! { |word| !word.split(//).include?(letter_guessed[0]) }
    end

    p @dictionary.size

    @letters_unguessed = create_letter_frequency_hash
  end

  # def filter_unguessed_words(hidden_word)
  #   hidden_letters = hidden_word.split(//)
  #   letter_indices = hidden_letters.each_index.select { |index| hidden_letters[index] != '_' }
  #
  #   @dictionary.select! do |word|
  #     letter_indices.each do |index|
  #       return false unless hidden_letters[index] == word.split(//)[index]
  #     end
  #     true
  #   end
  # end

  def game_over?
    @secret_word == render_hidden_word
  end
end

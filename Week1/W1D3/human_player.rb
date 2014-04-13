class HumanPlayer

  def initialize
    @correct_guesses = []
  end

  def pick_secret_word
    dictionary = File.readlines('dictionary.txt').map(&:chomp)

    loop do
      print "Enter a secret word: "
      secret_word = gets.chomp
      if dictionary.include?(secret_word)
        @secret_word = secret_word
        break
      end
      puts "Invalid word. Pick again."
    end
  end

  def receive_secret_length(length)
  end

  def guess
    loop do
      print "> "
      letter = gets.chomp
      return letter if ("a".."z").include?(letter)
      puts "Invalid input."
    end
  end

  def check_guess(guess)
    if @secret_word.split(//).include?(guess)
      @correct_guesses << guess
      return [true, render_hidden_word]
    end
    [false, render_hidden_word]
  end

  def handle_guess_response(response)
    puts "Letter doesn't exist" unless response
  end

  def render_hidden_word
    @secret_word.split(//).map do |letter|
      @correct_guesses.include?(letter) ? letter : "_"
    end.join
  end

  def game_over?
    @secret_word == render_hidden_word
  end

  def display_endgame_message
    puts "Congratulations computer, the human's word sucks!"
  end
end
class Mastermind

  def initialize
    @board = Array.new(10) { Array.new(2) }
    @secret_code = "RGBY" #generate_secret_code
    @turns = 10
  end

  def generate_secret_code
    colors = ["R", "G", "B", "Y", "O", "P"]
    # [].tap {|code| 4.times{|i|code << colors.sample}}

    ["R", "G", "B", "Y", "O", "P"].shuffle[0..3].join
  end

  def play
    begin
      display_board
      user_guess = prompt_user
      play_move(user_guess)

      @turns -= 1
    end until game_over?

    display_board
    display_end_message
  end

  def display_end_message
    if @board[@turns][0] == @secret_code
      puts "You win!"
    else
      puts "You lose..."
    end
    puts "Secret code was #{@secret_code}"
  end

  def game_over?
    return true if @board[@turns][0] == @secret_code || @turns.zero?
    false
  end

  def prompt_user
    loop do
      puts "Guess the secret code."
      user_guess = gets.chomp.upcase
      return user_guess if user_guess.split(//).uniq.join == user_guess
      puts "Invalid guess. Try again."
    end
  end

  def play_move(user_guess)
    @board[@turns-1][0] = user_guess
    @board[@turns-1][1] = guess_check(user_guess)
  end

  def guess_check(user_guess)
    guesses = user_guess.split(//)

    [].tap do |results|
      guesses.each_index do |i|
        if @secret_code.include?(guesses[i])
          results << (@secret_code[i] == guesses[i] ? :X : :O)
        end
      end
    end.sort.reverse
  end

  def display_board
    @board.reverse.each do |row|
      puts "#{row[0]} #{row[1].inspect}" unless row[0].nil?
    end
  end

end
require './human_player'
require './computer_player'

class Hangman
  attr_reader :guessing_player, :checking_player

  def initialize(guessing_player, checking_player)
    @guessing_player, @checking_player = guessing_player, checking_player
  end

  def display
    puts "Secret word: #{self.checking_player.render_hidden_word}"
  end

  def play_game
    self.checking_player.pick_secret_word
    self.guessing_player.receive_secret_length(self.checking_player.render_hidden_word.length)

    begin
      display
      guess = self.guessing_player.guess
      response = self.checking_player.check_guess(guess)
      self.guessing_player.handle_guess_response(response)
    end until self.checking_player.game_over?

    display
    self.checking_player.display_endgame_message
  end
end



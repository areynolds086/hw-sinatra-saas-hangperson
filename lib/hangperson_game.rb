class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  MAX_GUESSES = 7

 
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  attr_reader :word_with_guesses
  # def initialize()
  # end
  
  def initialize(word)
    new_game(word)
  end

 def new_game(word)
#set default values
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @wrong_guess_count = 0
    
    update_word
  end

def guess(letter)
    raise ArgumentError, "Argument is not a letter" unless letter =~ /[a-zA-Z]/ 
    raise RuntimeError, "Game has already ended" unless check_win_or_lose == :play
    
    guess = letter.downcase

    return false unless is_new_guess?(guess)
    
    if is_correct_guess?(guess)
      register_correct_guess(guess)
      update_word
    else
      register_wrong_guess(guess)
    end
    return true
  end


def is_correct_guess?(guess)
    @word.downcase.include?(guess)
  end

def is_new_guess?(guess)
    !@guesses.include?(guess) && !@wrong_guesses.include?(guess)
  end

def register_correct_guess(guess)
    return if @guesses.include?(guess)
    @guesses << guess
  end

def is_new_guess?(guess)
    !@guesses.include?(guess) && !@wrong_guesses.include?(guess)
  end

def register_wrong_guess(guess)
    return if @wrong_guesses.include?(guess)
    @wrong_guesses << guess
    @wrong_guess_count = @wrong_guess_count + 1
  end

def reached_max_guesses?
    @wrong_guess_count >= MAX_GUESSES
  end

 def update_word
    @word_with_guesses = ''
    @word.each_char do |letter|
      if @guesses.include?(letter)
        @word_with_guesses << letter
      else
        @word_with_guesses << '-'
      end
    end
  end

def guessed_complete_word?
    !reached_max_guesses? && !@word_with_guesses.include?('-')
  end

 def check_win_or_lose
    if reached_max_guesses?
      :lose
    elsif guessed_complete_word?
      :win
    else
      :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end



end

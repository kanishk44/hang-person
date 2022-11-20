class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def new(randomWord)
    @hangpersonGame = HangpersonGame.new(randomWord)
  end

  def guess_word(letter)
    if letter =~ /[[:alpha:]]/
      letter.downcase!
      if @word.include? letter and !@guesses.include? letter
        @guesses.concat letter
        return true
      elsif !@wrong_guesses.include? letter and !@word.include? letter
        @wrong_guesses.concat letter
        return true
      else
        return false
      end
    else
      letter = :invalid
      raise ArgumentError
    end
  end

  def check_word
    ans = ""
    @word.each_char do |let|
      if @guesses.include? let
        ans.concat let
      else
        ans.concat '-'
      end
    end
    return ans
  end

  def game_result
    count = 0
    return :lose if @wrong_guesses.length >= 7
    @word.each_char do |let|
      count += 1 if @guesses.include? let # if let =~ /[#{@guesses}]/
    end
    if count == @word.length then :win
    else :play end
  end

end
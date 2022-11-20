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

  def new(word)
    @hangpersonGame = HangpersonGame.new(word)
  end

  def guess_word(let)
    if let =~ /[[:alpha:]]/
      let.downcase!
      if @word.include? let and !@guesses.include? let
        @guesses.concat let
        return true
      elsif !@wrong_guesses.include? char and !@word.include? let
        @wrong_guesses.concat let
        return true
      else
        return false
      end
    else
      let = :invalid
      raise ArgumentError
    end
  end

  def word_with_guesses
    ans = ""
    @word.each_char do |letter|
      if @guesses.include? letter
        ans.concat letter
      else
        ans.concat '-'
      end
    end
    return ans
  end

  def game_result
    count = 0
    return :lose if @wrong_guesses.length >= 7
    @word.each_char do |letter|
      count += 1 if @guesses.include? letter # if letter =~ /[#{@guesses}]/
    end
    if count == @word.length then :win
    else :play end
  end

end
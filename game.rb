class Game 
  attr_reader :secret_word, :secret_word_array, :missed_letters, :guessed_letters, :try

  def initialize(secret_word)
    @secret_word = secret_word
    @secret_word_array = secret_word.split("")
    @missed_letters = []
    @guessed_letters = @secret_word_array.map {|word| word = "?"}
    @try = 1
  end

  def Game.random_word 
    words = File.read("5desk.txt")
    random_word = words.split.sample.downcase 
    
    if random_word.length < 5 || random_word.length > 12
      Game.random_word
    else
      random_word
    end
  end
  
  def show_missed_letters
    puts "Missed letters: #{@missed_letters.join(", ")}"; puts 
  end

  def show_guessed_letters
    puts "Guessed letters: #{@guessed_letters.join(" | ")}"; puts
  end

  def get_guess
    guess = ""
    loop do 
      print "Type in a letter: "; guess = gets.chomp
      redo if @missed_letters.include?(guess) || @guessed_letters.include?(guess)
      break if (guess.length == 1 && guess.to_i == 0)
    end
    guess.downcase
  end

  def check_if_include(guess)
    if @secret_word_array.include?(guess)
      (@secret_word_array.length).times { |i| @guessed_letters[i] = guess if @secret_word_array[i] == guess } 
    else
      @missed_letters << guess
      @try += 1
    end
  end

  def won?
    @guessed_letters == @secret_word_array
  end

  def win_message
    puts
    show_guessed_letters
    puts "You won! Secret word: #{@secret_word}"
  end

  def lost?
    @try == 9 && @guessed_letters != @secret_word_array
  end

  def lose_message
    puts
    show_guessed_letters
    puts "You lost. Secret word: #{@secret_word}"
  end

  def play
    puts @secret_word

    while @try < 9
      puts "-(Tries left: #{9 - @try})"; puts
      
      show_missed_letters
      show_guessed_letters
  
      guess = get_guess
  
      check_if_include(guess)
  
      return win_message if won?
      return lose_message if lost?
  
      puts
    end
  end
end

game = Game.new(Game.random_word)

game.play
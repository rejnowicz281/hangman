require "yaml"

class Game 
  attr_reader :secret_word, :secret_word_array, :missed_letters, :guessed_letters, :try

  def initialize(secret_word)
    @secret_word = secret_word
    @secret_word_array = secret_word.split("")
    @missed_letters = []
    @guessed_letters = secret_word.split("").map {|word| word = "?"}
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

  def save?
    save_or_not = ""
    loop do 
      print "Would you like to save the game?(Y/N): "; save_or_not = gets.chomp.upcase; puts 
      break if save_or_not == "Y" || save_or_not == "N"
    end

    case save_or_not
      when "Y"
        save_slot = ""
        loop do  
          print "Which slot do you want do save on?(save1, save2, save3, save4, save5): "; save_slot = gets.chomp; puts 
          break if save_slot == "save1" || save_slot == "save2" || save_slot == "save3" || save_slot == "save4" || save_slot == "save5"
        end

        slot = File.open("saves/#{save_slot}.yaml", "w")
        slot.write to_yaml
        slot.close
      when "N"
        return
    end
  end

  def load?
    load_or_not = ""
    loop do 
      print "Would you like to load a game?(Y/N): "; load_or_not = gets.chomp.upcase; puts 
      break if load_or_not == "Y" || load_or_not == "N"
    end

    case load_or_not
      when "Y"
        save_slot = ""
        loop do  
          print "Which slot do you want to load?(save1, save2, save3, save4, save5): "; save_slot = gets.chomp; puts 
          break if save_slot == "save1" || save_slot == "save2" || save_slot == "save3" || save_slot == "save4" || save_slot == "save5"
        end

        slot = File.read("saves/#{save_slot}.yaml")
        game = YAML::load(slot)
        game.play
      when "N"
        return
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
    puts "Welcome to hangman!"; puts
    load?

    while @try < 9
      puts "-(Tries left: #{9 - @try})"; puts
      
      show_missed_letters
      show_guessed_letters

      save?
  
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
class Hangman
  attr_reader :saves
  
  def initialize(incorrect_guesses = 8, secret_word = random_word)
      @secret_word = secret_word
      @incorrect_guesses = incorrect_guesses
      @correct_letters = Array.new(secret_word.length, "_")
      @incorrect_letters = []
  end 

  def play
      @ask_to_save = true
      puts "Welcome to Hangman!"
      load?

      loop do
          if @incorrect_guesses == 0 
              puts "You lose. Secret word: #{@secret_word}"
              return
          elsif @correct_letters.join("") == @secret_word
              puts "You win. Secret word: #{@secret_word}"
              return
          end 
          puts "-- #{@incorrect_guesses} incorrect guesses left --"
          puts
          puts "#{@correct_letters.join(" | ")}"
          puts "\nIncorrect: #{@incorrect_letters.join(" | ")}" unless @incorrect_letters.empty?
          puts
          
          save? if @ask_to_save

          letter = get_letter
          secret_array = @secret_word.split("")
          
          if secret_array.include?(letter)
              secret_array.length.times { |i| @correct_letters[i] = letter if letter == secret_array[i]}
          else
              @incorrect_letters << letter 
              @incorrect_guesses -= 1
          end 
          puts
      end 
  end 

  private
  def random_word
      dictionary = File.read("5desk.txt").split
      random_word = ""
      random_word = dictionary.sample.downcase until random_word.length > 5 && random_word.length < 12
      random_word
  end

  def get_letter
      print "Type in a letter: "; letter = gets.chomp
      return (letter.length != 1 || letter.to_i != 0 || letter == "0" || @incorrect_letters.include?(letter) || @correct_letters.include?(letter)) ? get_letter : letter.downcase
  end 

  def load?
      saves_array = Dir.children("saves")
      return (puts "\nNo available saves.") if saves_array.empty?
      print "Would you like to load a game?(yes, no): "; choice = gets.chomp
      if choice == "yes"
          puts "List of available saves: "
          puts
          saves_array.length.times do |i|
              save = File.read("saves/save#{i}.marshal")
              puts "Save #{i}), Time of save (#{Marshal::load(save).time_of_save})"
          end 
          print "Choose the save you want to load(type index): "; load_idx = gets.chomp
          save = File.read("saves/save#{load_idx}.marshal")
          new_game = Marshal::load(save)
          return new_game.play
      end 
  end 

  def save?
      saves_array = Dir.children("saves")
      print "Would you like to save the game?(yes, no, dont_ask): "; choice = gets.chomp
      if choice == "yes"
          @time_of_save = Time.now
          save = File.new("saves/save#{saves_array.length}.marshal", "w")
          save.write "#{Marshal::dump(self)}"
          save.close
          puts "\nGame saved on #{@time_of_save}"
          puts
      elsif choice == "dont_ask"
        @ask_to_save = false
      end 
  end  

  def time_of_save
    @time_of_save
  end 

  def secret_word 
    @secret_word
  end 
end

game = Hangman.new

game.play
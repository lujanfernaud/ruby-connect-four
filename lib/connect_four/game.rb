class Game
  attr_accessor :players, :human1, :human2
  attr_reader   :board, :computer, :judge

  def initialize
    @board    = Board.new(self)
    @judge    = Judge.new(self, board)
    @players  = 1
    @human1   = Player.new(name: "Human 1", mark: "X", board: board)
    @human2   = Player.new(name: "Human 2", mark: "O", board: board)
    @computer = Computer.new(mark: "O", human_mark: human1.mark, board: board)
  end

  def setup
    board.print_board
    set_players
    ask_players_names if players == 2
    start
  rescue Interrupt
    exit_game
  end

  def retry_turn(player)
    column = introduce_column(player, print_board: false)
    player.throw(column)
    judge.check_for_winner(player)
  end

  def try_again
    loop do
      case STDIN.gets.chomp.downcase
      when "y"
        board.reset
        start
      when "n"
        exit_game
      else
        board.print_board
        puts "Please type 'y' or 'n'."
      end
    end
  end

  private

  def start
    loop do
      board.print_board
      first_turn
      second_turn
    end
  rescue Interrupt
    exit_game
  end

  def first_turn
    human1.throw(introduce_column(human1))
    judge.check_for_winner(human1)
  end

  def second_turn
    case players
    when 1
      computer.throw
      judge.check_for_winner(computer)
    when 2
      human2.throw(introduce_column(human2))
      judge.check_for_winner(human2)
    end
  end

  def introduce_column(player = computer, print_board: true)
    board.print_board if print_board
    case players
    when 1 then puts "Introduce a column:"
    when 2 then puts "#{player.name}, introduce a column:"
    end
    check_inputted_column
  end

  def check_inputted_column
    loop do
      input = STDIN.gets.chomp
      return input if input =~ /^[1-7]$/
      exit_game    if input == "exit".downcase

      board.print_board
      puts "'#{input}' is not a correct column.\n\nIntroduce a column:"
    end
  end

  def set_players
    puts "Choose players, 1 or 2?"

    loop do
      input = STDIN.gets.chomp.to_i
      return self.players = input if input.to_s =~ /^[1-2]$/

      board.print_board
      puts "1 or 2 players?"
    end
  end

  def ask_players_names
    board.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
    board.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end

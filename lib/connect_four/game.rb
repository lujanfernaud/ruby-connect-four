class Game
  attr_reader :board, :judge, :players

  def initialize(players)
    @board   = Board.new(self)
    @judge   = Judge.new(self, board)
    @players = players
  end

  def start_game
    players_turns
  rescue Interrupt
    exit_game
  end

  def retry_turn(player)
    column = ask_for_column(player, print_board: false)
    player.throw(column, board)
    judge.check_for_winner(player)
  end

  def try_again
    loop do
      case STDIN.gets.chomp.downcase
      when "y" then restart_game
      when "n" then exit_game
      else type_yes_or_no
      end
    end
  end

  private

  def players_turns
    loop do
      players.each do |player|
        column = ask_for_column(player)
        player.throw(column, board)
        judge.check_for_winner(player)
      end
    end
  end

  def ask_for_column(player, print_board: true)
    board.print_board if print_board
    puts "#{player.name}, introduce a column:"
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

  def type_yes_or_no
    board.print_board
    puts "Please type 'y' or 'n'."
  end

  def restart_game
    board.reset
    start_game
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end

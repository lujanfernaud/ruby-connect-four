class Game
  attr_accessor :human1, :human2
  attr_reader   :board,  :judge

  def initialize(human1, human2)
    @board  = Board.new(self)
    @judge  = Judge.new(self, board)
    @human1 = human1
    @human2 = human2
  end

  def start_game
    loop do
      board.print_board
      first_turn
      second_turn
    end
  rescue Interrupt
    exit_game
  end

  def retry_turn(player)
    column = introduce_column(player, print_board: false)
    player.throw(column, board)
    judge.check_for_winner(player)
  end

  def try_again
    loop do
      case STDIN.gets.chomp.downcase
      when "y" then restart_game
      when "n" then exit_game
      else
        board.print_board
        puts "Please type 'y' or 'n'."
      end
    end
  end

  private

  def first_turn
    column = introduce_column(human1)
    human1.throw(column, board)
    judge.check_for_winner(human1)
  end

  def second_turn
    column = introduce_column(human2)
    human2.throw(column, board)
    judge.check_for_winner(human2)
  end

  def introduce_column(player, print_board: true)
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

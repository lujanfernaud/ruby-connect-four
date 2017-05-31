class GameSetup
  attr_accessor :player1, :player2
  attr_reader   :players, :game, :printer, :board

  def initialize
    @player1 = Player.new(name: "Player 1", mark: "X")
    @player2 = Player.new(name: "Player 2", mark: "O")
    @players = [player1, player2]
    @game    = Game.new(players)
    @printer = game.printer
    @board   = game.board
  end

  def setup
    ask_players_names
    game.start_game
  rescue Interrupt
    game.exit_game
  end

  private

  def ask_players_names
    printer.print_board
    puts "Player 1 name:"
    player1.name = STDIN.gets.chomp
    printer.print_board
    puts "Player 2 name:"
    player2.name = STDIN.gets.chomp
  end
end

class GameSetup
  attr_accessor :human1, :human2
  attr_reader   :game,   :board

  def initialize
    @human1 = Player.new(name: "Human 1", mark: "X")
    @human2 = Player.new(name: "Human 2", mark: "O")
    @game   = Game.new(human1, human2)
    @board  = game.board
  end

  def setup
    board.print_board
    ask_players_names
    game.start_game
  rescue Interrupt
    game.exit_game
  end

  private

  def ask_players_names
    board.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
    board.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp
  end
end

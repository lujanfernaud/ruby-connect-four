require "spec_helper"

describe Game do
  before :all do
    @game = Game.new
  end

  describe "attributes" do
    it "has a board" do
      expect(@game.board).to be_a(Board)
    end

    it "has number of players" do
      expect(@game.players).to be_an(Integer)
    end

    it "has one player by default" do
      expect(@game.players).to eql(1)
    end

    it "allows reading and writing for :players" do
      @game.players = 2
      expect(@game.players).to eql(2)
      @game.players = 1
    end

    it "has human players" do
      expect(@game.human1).to be_a(Player)
      expect(@game.human2).to be_a(Player)
    end

    it "has a computer player" do
      expect(@game.computer).to be_a(Computer)
    end

    it "sends board to all players" do
      players = [@game.human1, @game.human2, @game.computer]
      players.each do |player|
        expect(player.board).to respond_to(:grid)
      end
    end
  end

  describe "#setup" do
    it "prints board, sets players, asks names if 2 and starts game" do
      expect(@game.board).to receive(:print_board)
      expect(@game).to receive(:set_players)
      expect(@game).to receive(:ask_players_names) if @game.players == 2
      expect(@game).to receive(:start)
      @game.setup
    end
  end

  describe "#retry_turn" do
    it "asks player to introduce position again without printing board" do
      player = @game.human1
      column = "1"
      expect(STDOUT).to receive(:puts).with("Introduce a column:")
      allow(STDIN).to receive(:gets).and_return(column)
      @game.retry_turn(player)
    end
  end
end

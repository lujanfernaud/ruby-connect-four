require "spec_helper"

describe Game do
  before :all do
    @game = Game.new
  end

  describe "attributes" do
    it "has a board" do
      expect(@game.board).to be_a(Board)
    end

    it "has human players" do
      expect(@game.human1).to be_a(Player)
      expect(@game.human2).to be_a(Player)
    end

    it "sends board to all players" do
      players = [@game.human1, @game.human2]
      players.each do |player|
        expect(player.board).to respond_to(:grid)
      end
    end
  end

  describe "#setup" do
    it "prints board, asks names and starts game" do
      expect(@game.board).to receive(:print_board)
      expect(@game).to receive(:ask_players_names)
      expect(@game).to receive(:start_game)
      @game.setup
    end
  end

  describe "#retry_turn" do
    it "asks player to introduce position again without printing board" do
      player = @game.human1
      column = "1"
      expect(STDOUT).to receive(:puts).with("#{player.name}, introduce a column:")
      allow(STDIN).to receive(:gets).and_return(column)
      @game.retry_turn(player)
    end
  end
end

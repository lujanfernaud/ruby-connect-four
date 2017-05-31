require "spec_helper"

describe Game do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:game)    { Game.new(player1, player2) }

  describe "attributes" do
    it "has a board" do
      expect(game.board).to be_a(Board)
    end

    it "has human players" do
      expect(game.human1).to be_a(Player)
      expect(game.human2).to be_a(Player)
    end
  end

  describe "#start_game" do
    it "prints board and gives turns to players" do
      allow(game).to receive(:loop).and_yield
      expect(game.board).to receive(:print_board)
      expect(game).to receive(:first_turn)
      expect(game).to receive(:second_turn)
      game.start_game
    end
  end

  describe "#retry_turn" do
    it "asks player to introduce position again without printing board" do
      player = player1
      column = "1"
      expect(STDOUT).to receive(:puts)
        .with("#{player.name}, introduce a column:")
      allow(STDIN).to receive(:gets).and_return(column)
      game.retry_turn(player)
    end
  end

  describe "#try_again" do
    before do
      allow(game).to receive(:loop).and_yield
    end

    it "restarts game if 'y'" do
      allow(STDIN).to receive(:gets).and_return("y")
      expect(game).to receive(:restart_game)
      game.try_again
    end

    it "exits game if 'n'" do
      allow(STDIN).to receive(:gets).and_return("n")
      expect(game).to receive(:exit_game)
      game.try_again
    end

    it "asks to type 'y' or 'n'" do
      allow(STDIN).to receive(:gets).and_return("maybe")
      expect(game.board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Please type 'y' or 'n'.")
      game.try_again
    end
  end
end

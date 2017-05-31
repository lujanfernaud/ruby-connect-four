require "spec_helper"

describe Game do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { Game.new(players) }
  let(:printer) { game.printer }

  describe "attributes" do
    it "has a board" do
      expect(game.board).to be_a(Board)
    end

    it "has a players array" do
      expect(players).to match([player1, player2])
    end

    it "each player is a Player object" do
      players.each { |player| expect(player).to be_a(Player) }
    end
  end

  describe "#start_game" do
    it "gives turns to players" do
      expect(game).to receive(:players_turns)
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
      expect(printer).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Please type 'y' or 'n'.")
      game.try_again
    end
  end
end

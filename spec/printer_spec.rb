require "spec_helper"

describe Printer do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { Game.new(players) }
  let(:board)   { Board.new(game) }
  let(:printer) { board.printer }

  describe "attributes" do
    it "allows reading for :board" do
      raise unless printer.board
    end
  end

  describe "#print_board" do
    it "prints board" do
      expect(printer).to receive(:system).with("clear")
      expect(printer).to receive(:system).with("cls")
      expect(STDOUT).to receive(:puts).with("\n")
      expect(printer).to receive(:print_game_title)
      expect(STDOUT).to receive(:puts).with("\n")
      expect(printer).to receive(:print_game_grid)
      expect(STDOUT).to receive(:puts).with("\n")
      printer.print_board
    end
  end
end

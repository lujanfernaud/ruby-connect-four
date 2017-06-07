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
    before do
      allow(printer).to receive(:system).with("clear")
      allow(printer).to receive(:system).with("cls")
      allow(printer).to receive(:puts).with("\n")
      allow(printer).to receive(:print_game_title)
      allow(printer).to receive(:puts).with("\n")
      allow(printer).to receive(:print_game_grid)
      allow(printer).to receive(:puts).with("\n")
      printer.print_board
    end

    it "prints title" do
      expect(printer).to have_received(:print_game_title)
    end

    it "prints grid" do
      expect(printer).to have_received(:print_game_grid)
    end
  end
end

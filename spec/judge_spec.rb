describe Judge do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { Game.new(players) }
  let(:printer) { game.printer }
  let(:judge)   { game.judge }
  let(:board)   { judge.board }

  describe "attributes" do
    it "has a Game object" do
      expect(judge.game).to be_a(Game)
    end

    it "has a Board object" do
      expect(judge.board).to be_a(Board)
    end
  end

  describe "#check_for_winner" do
    before do
      allow(printer).to receive(:print_board)
      allow(game).to receive(:try_again)
    end

    it "checks board and finds Sandi as a winner" do
      board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                    ["-", "-", "-", "-", "-", "-", "-"],
                    ["-", "-", "-", "-", "-", "-", "-"],
                    ["-", "-", "-", "-", "O", "O", "O"],
                    ["-", "-", "-", "-", "O", "X", "X"],
                    ["X", "X", "X", "X", "O", "O", "X"]]
      allow(judge).to receive(:puts).with("Sandi WINS! Try again? (y/n)")
      judge.check_for_winner(player1)
      expect(judge).to have_received(:puts).with("Sandi WINS! Try again? (y/n)")
    end

    it "checks board and finds Matz as a winner" do
      board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                    ["-", "-", "-", "-", "-", "-", "-"],
                    ["-", "-", "O", "-", "-", "-", "-"],
                    ["-", "-", "X", "O", "X", "O", "O"],
                    ["-", "X", "X", "X", "O", "X", "X"],
                    ["X", "O", "X", "X", "O", "O", "X"]]
      allow(judge).to receive(:puts).with("Matz WINS! Try again? (y/n)")
      judge.check_for_winner(player2)
      expect(judge).to have_received(:puts).with("Matz WINS! Try again? (y/n)")
    end

    it "finishes game because there's no winner" do
      board.grid = [["O", "X", "O", "O", "O", "X", "O"],
                    ["O", "O", "X", "X", "X", "O", "X"],
                    ["X", "X", "X", "O", "O", "X", "O"],
                    ["X", "O", "O", "X", "O", "X", "O"],
                    ["O", "X", "X", "O", "X", "O", "X"],
                    ["X", "O", "X", "O", "X", "O", "X"]]
      allow(judge).to receive(:puts)
        .with("There's no winner. Try again? (y/n)")
      judge.check_for_winner(player1)
      expect(judge).to have_received(:puts)
        .with("There's no winner. Try again? (y/n)")
    end
  end
end

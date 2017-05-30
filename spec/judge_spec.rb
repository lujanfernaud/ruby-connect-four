require "spec_helper"

describe Judge do
  before do
    @game         = Game.new
    @judge        = @game.judge
    @board        = @judge.board
    @player1      = @game.human1
    @player1.name = "Sandi"
    @player2      = @game.human2
    @player2.name = "Matz"
  end

  describe "attributes" do
    it "has a Game object" do
      expect(@judge.game).to be_a(Game)
    end

    it "has a Board object" do
      expect(@judge.board).to be_a(Board)
    end
  end

  describe "#check_for_winner" do
    it "checks board and finds Sandi as a winner" do
      @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                     ["-", "-", "-", "-", "-", "-", "-"],
                     ["-", "-", "-", "-", "-", "-", "-"],
                     ["-", "-", "-", "-", "O", "O", "O"],
                     ["-", "-", "-", "-", "O", "X", "X"],
                     ["X", "X", "X", "X", "O", "O", "X"]]
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Sandi WINS! Try again? (y/n)")
      expect(@game).to receive(:try_again)
      @judge.check_for_winner(@player1)
    end

    it "checks board and finds Matz as a winner" do
      @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                     ["-", "-", "-", "-", "-", "-", "-"],
                     ["-", "-", "O", "-", "-", "-", "-"],
                     ["-", "-", "X", "O", "X", "O", "O"],
                     ["-", "X", "X", "X", "O", "X", "X"],
                     ["X", "O", "X", "X", "O", "O", "X"]]
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Matz WINS! Try again? (y/n)")
      expect(@game).to receive(:try_again)
      @judge.check_for_winner(@player2)
    end

    it "finishes game because there's no winner" do
      @board.grid = [["O", "X", "O", "O", "O", "X", "O"],
                     ["O", "O", "X", "X", "X", "O", "X"],
                     ["X", "X", "X", "O", "O", "X", "O"],
                     ["X", "O", "O", "X", "O", "X", "O"],
                     ["O", "X", "X", "O", "X", "O", "X"],
                     ["X", "O", "X", "O", "X", "O", "X"]]
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts)
        .with("There's no winner. Try again? (y/n)")
      expect(@game).to receive(:try_again)
      @judge.check_for_winner(@player1)
    end
  end
end

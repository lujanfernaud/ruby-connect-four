require "spec_helper"

describe Computer do
  before :all do
    @game     = Game.new
    @board    = @game.board
    @computer = @game.computer
  end

  describe "attributes" do
    it "has a name" do
      expect(@computer.name).to eql("Computer")
    end

    it "has a mark" do
      expect(@computer.mark).to eql("O")
    end

    it "knows about board" do
      expect(@computer).to respond_to(:board)
    end

    it "has hability to throw" do
      expect(@computer).to respond_to(:throw)
    end
  end

  describe "#throw" do
    before do
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Computer turn...")
      allow(@computer).to receive(:sleep)
    end

    context "with 2 consecutive human marks in a row" do
      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "O", "O"],
                       ["-", "-", "-", "-", "-", "X", "X"]]
        @computer.throw
        expect(@board.grid[5][4]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "O", "-", "-", "-"],
                       ["-", "-", "X", "X", "-", "-", "-"]]
        @computer.throw
        expect([@board.grid[5][1], @board.grid[5][4]]).to include("O")
      end
    end

    context "with 3 consecutive human marks in a row" do
      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "O", "O"],
                       ["-", "-", "-", "-", "X", "X", "X"]]
        @computer.throw
        expect(@board.grid[5][3]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "O", "O", "-", "-", "-"],
                       ["-", "-", "X", "X", "X", "-", "-"]]
        @computer.throw
        expect([@board.grid[5][1], @board.grid[5][5]]).to include("O")
      end
    end

    context "with 2 consecutive computer marks in a row" do
      it "places mark next to computer mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "O", "O"],
                       ["X", "-", "-", "-", "O", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][4]).to eql("O")
      end

      it "places mark next to computer mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "O", "O", "-", "X", "X"]]
        @computer.throw
        expect([@board.grid[5][1], @board.grid[5][4]]).to include("O")
      end
    end

    context "with 3 consecutive computer marks in a row" do
      it "places mark next to computer mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "O", "O", "O"],
                       ["X", "-", "-", "X", "O", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][3]).to eql("O")
      end

      it "places mark next to computer mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["X", "-", "-", "-", "-", "-", "-"],
                       ["X", "-", "O", "O", "O", "-", "X"]]
        @computer.throw
        expect([@board.grid[5][1], @board.grid[5][5]]).to include("O")
      end
    end
  end
end

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
                       ["O", "-", "-", "-", "-", "-", "-"],
                       ["X", "X", "-", "-", "-", "-", "-"]]
        @computer.throw
        expect(@board.grid[5][2]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["O", "O", "-", "-", "-", "-", "-"],
                       ["X", "X", "X", "-", "-", "-", "-"]]
        @computer.throw
        expect(@board.grid[5][3]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["X", "-", "-", "X", "-", "-", "O"]]
        @computer.throw
        expect(@board.grid[5][1]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "O", "-", "-", "-"],
                       ["-", "-", "X", "X", "-", "-", "-"]]
        @computer.throw
        expect(@board.grid[5][4]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "O"],
                       ["-", "-", "-", "-", "-", "X", "X"]]
        @computer.throw
        expect(@board.grid[5][3]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["O", "-", "-", "-", "O", "-", "-"],
                       ["X", "X", "-", "X", "O", "X", "O"],
                       ["X", "O", "X", "O", "X", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][2]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["O", "-", "-", "-", "-", "-", "-"],
                       ["X", "O", "O", "X", "-", "X", "X"],
                       ["X", "O", "X", "O", "X", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][4]).to eql("O")
      end

      it "places mark next to human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["O", "-", "-", "-", "-", "-", "-"],
                       ["X", "O", "O", "X", "X", "-", "X"],
                       ["X", "O", "X", "O", "X", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][5]).to eql("O")
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
                       ["O", "-", "-", "-", "O", "-", "-"],
                       ["X", "X", "X", "-", "X", "X", "O"],
                       ["X", "O", "X", "O", "X", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][3]).to eql("O")
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
                       ["X", "-", "-", "X", "O", "X", "X"]]
        @computer.throw
        expect(@board.grid[4][3]).to eql("O")
      end

      it "places mark next to computer mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "O", "O", "-", "X", "X"]]
        @computer.throw
        expect([@board.grid[5][0], @board.grid[5][1]]).to include("O")
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

    context "with 2 consecutive human marks in a column" do
      it "places mark on top of human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "X"],
                       ["-", "-", "-", "-", "-", "O", "X"]]
        @computer.throw
        expect(@board.grid[3][6]).to eql("O")
      end
    end

    context "with 2 consecutive computer marks in a column" do
      it "places mark on top of computer mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "O"],
                       ["-", "O", "-", "-", "O", "X", "X"],
                       ["-", "O", "-", "-", "X", "O", "X"]]
        @computer.throw
        expect(@board.grid[3][1]).to eql("O")
      end
    end

    context "with 3 consecutive human marks in a column" do
      it "places mark on top of human mark" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "X"],
                       ["-", "-", "-", "-", "-", "O", "X"],
                       ["-", "-", "-", "-", "-", "O", "X"]]
        @computer.throw
        expect(@board.grid[2][6]).to eql("O")
      end
    end

    context "with 3 consecutive human and computer marks in columns" do
      it "places mark on top of computer mark and wins" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "O", "X"],
                       ["-", "-", "-", "-", "-", "O", "X"],
                       ["-", "X", "-", "-", "-", "O", "X"]]
        @computer.throw
        expect(@board.grid[2][5]).to eql("O")
      end
    end

    context "with 2 consecutive human marks in a diagonal" do
      it "blocks human diagonal" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "X", "O", "-", "-", "-", "-"],
                       ["X", "O", "X", "X", "-", "O", "X"]]
        @computer.throw
        expect(@board.grid[3][2]).to eql("O")
      end

      it "places mark on computer diagonal" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "X", "O", "O", "-", "-", "-"],
                       ["X", "O", "X", "X", "-", "O", "X"]]
        @computer.throw
        expect(@board.grid[3][3]).to eql("O")
      end
    end

    context "with 3 consecutive human marks in a diagonal" do
      it "places mark on corresponding column" do
        @board.grid = [["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "-", "-", "-", "-"],
                       ["-", "-", "-", "O", "X", "-", "-"],
                       ["-", "-", "-", "X", "O", "X", "-"],
                       ["-", "-", "-", "O", "X", "O", "X"]]
        @computer.throw
        expect(@board.grid[2][3]).to eql("O")
      end
    end
  end
end

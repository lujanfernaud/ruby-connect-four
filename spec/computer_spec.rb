require "spec_helper"

describe Computer do
  before :all do
    @game     = Game.new
    @board    = @game.board
    @computer = @game.computer
  end

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

  describe "#throw" do
    it "prints 'Computer turn...' and places mark on board" do
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Computer turn...")
      allow(@computer).to receive(:sleep)
      expect(@board).to receive(:position_mark_in_column)
      @computer.throw
    end
  end

  describe "#choose_location" do
  end

  describe "#check_rows" do
    context "on first iteration" do
      context "with 1 human mark" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 0)).to eql(false)
          @computer.check_rows(iteration: 0)
        end
      end

      context "with 2 human marks" do
        it "returns index of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 0)).to eql(3)
          @computer.check_rows(iteration: 0)
        end
      end

      context "with 3 human marks" do
        it "returns index + 1 of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "O", "-", "-"],
                         ["X", "X", "X", "-"]]
          expect(@computer.check_rows(iteration: 0)).to eql(4)
          @computer.check_rows(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks" do
        it "returns index + 1 of first free position next to computer" do
          @board.grid = [["O", "O", "O", "-"],
                         ["X", "O", "X", "X"],
                         ["O", "O", "X", "X"],
                         ["X", "X", "O", "O"]]
          expect(@computer.check_rows(iteration: 0)).to eql(4)
          @computer.check_rows(iteration: 0)
        end
      end
    end

    context "on second iteration" do
      context "with 1 human mark" do
        it "returns index + 1 of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 1)).to eql(1)
          @computer.check_rows(iteration: 1)
        end
      end

      context "with 2 human marks" do
        it "returns index + 1 of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "O", "-", "-"],
                         ["X", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 1)).to eql(3)
          @computer.check_rows(iteration: 1)
        end
      end

      context "with 2 computer marks and 0 human marks" do
        it "returns index + 1 of first free position next to computer" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "O", "-", "-"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_rows(iteration: 1)).to eql(3)
          @computer.check_rows(iteration: 1)
        end
      end

      context "with 2 computer marks and 1 human mark" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "O", "-", "X"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_rows(iteration: 1)).to eql(false)
          @computer.check_rows(iteration: 1)
        end
      end
    end

    context "on third iteration" do
      context "with 1 computer mark and 0 human marks" do
        it "returns index + 1 of first free position next to computer" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["O", "O", "X", "X"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_rows(iteration: 2)).to eql(2)
          @computer.check_rows(iteration: 2)
        end
      end
    end
  end

  describe "#check_columns" do
    context "on first iteration" do
      context "with no empty slots" do
        it "returns 'false'" do
          @board.grid = [["X", "O", "X", "-"],
                         ["O", "O", "X", "O"],
                         ["X", "X", "O", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(false)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 1 human mark" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_columns(iteration: 0)).to eql(false)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 2 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "O", "X"],
                         ["-", "O", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(4)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 3 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["X", "O", "-", "O"],
                         ["X", "O", "O", "X"],
                         ["X", "O", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(1)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks" do
        it "returns column + 1" do
          @board.grid = [["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "O", "O", "X"],
                         ["X", "O", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(2)
          @computer.check_columns(iteration: 0)
        end
      end
    end

    context "on second iteration" do
      context "with 1 human mark" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_columns(iteration: 1)).to eql(2)
          @computer.check_columns(iteration: 1)
        end
      end

      context "with 2 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["X", "O", "-", "-"],
                         ["X", "X", "O", "-"]]
          expect(@computer.check_columns(iteration: 1)).to eql(1)
          @computer.check_columns(iteration: 1)
        end
      end
    end

    context "on third iteration" do
      context "with 1 computer mark and 0 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "-", "-"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_columns(iteration: 2)).to eql(3)
          @computer.check_columns(iteration: 2)
        end
      end
    end
  end

  describe "#check_diagonals" do
    context "on first iteration" do
      context "with no empty slots (from left bottom)" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "X"],
                         ["O", "O", "O", "X"],
                         ["X", "O", "X", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(false)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with no empty slots (from right bottom)" do
        it "returns 'false'" do
          @board.grid = [["X", "O", "X", "-"],
                         ["O", "O", "X", "O"],
                         ["X", "X", "O", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(false)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 2 human marks and 0 computer marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(3)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 2 human marks and 0 computer marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(2)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 human marks and 0 computer marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "O", "X", "O"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(4)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 human marks and 0 computer marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "X", "O", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(1)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "O", "X"],
                         ["X", "O", "X", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(4)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "O", "X", "X"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "X", "O"]]
          expect(@computer.diagonal_from_right_bottom(iteration: 0)).to eql(1)
          @computer.diagonal_from_right_bottom(iteration: 0)
        end
      end
    end

    context "on second iteration" do
      context "with 2 human marks and 0 computer marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(3)
          @computer.check_diagonals(iteration: 1)
        end
      end

      context "with 2 human marks and 0 computer marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(2)
          @computer.check_diagonals(iteration: 1)
        end
      end

      context "with 2 computer marks and 0 human marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(3)
          @computer.check_diagonals(iteration: 1)
        end
      end

      context "with 2 computer marks and 0 human marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "X", "O"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(3)
          @computer.check_diagonals(iteration: 1)
        end
      end
    end
  end
end

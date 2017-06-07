describe Board do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { Game.new(players) }
  let(:board)   { described_class.new(game) }
  let(:printer) { board.printer }

  before do
    board.grid = [["-", "-", "-", "-", "-", "-", "O"],
                  ["-", "-", "-", "-", "-", "-", "X"],
                  ["-", "-", "-", "-", "-", "-", "O"],
                  ["-", "-", "-", "-", "-", "-", "X"],
                  ["-", "-", "-", "-", "-", "-", "O"],
                  ["-", "X", "O", "-", "-", "O", "X"]]
  end

  describe "attributes" do
    it "allows reading and writing for :grid" do
      board.grid[0][1] = "X"
      expect(board.grid[0][1]).to eql("X")
      board.grid[0][1] = "-"
    end

    it "allows reading for :game" do
      raise unless board.game
    end

    it "allows reading for :diagonals" do
      raise unless board.diagonals
    end

    it "has a Printer object" do
      expect(printer).to be_a(Printer)
    end
  end

  describe "#place_mark_in_column" do
    it "takes column and player as arguments" do
      expect { board.place_mark_in_column(2, player1) }.not_to raise_error
    end

    it "checks what position is available in the column and places mark" do
      board.grid[5][1] = "X"
      board.place_mark_in_column(1, player1)
      expect(board.grid[4][1]).to eql("X")
    end
  end

  describe "#column_available?" do
    it "checks and returns 'true'" do
      column = 2
      expect(board.column_available?(column)).to be(true)
      board.column_available?(column)
    end

    it "checks and returns 'false'" do
      column = 7
      expect(board.column_available?(column)).to be(false)
      board.column_available?(column)
    end
  end

  describe "#the_column_is_full" do
    let(:column) { 1 }

    before do
      allow(printer).to receive(:print_board)
      allow(board).to receive(:puts)
        .with("The column #{column + 1} is full.\n\n")
      allow(game).to receive(:retry_turn).with(player1)
    end

    it "prints 'The column 1 is full.'" do
      board.the_column_is_full(column, player1)
      expect(board).to have_received(:puts)
        .with("The column #{column + 1} is full.\n\n")
    end
  end

  describe "#reset" do
    it "resets board" do
      new_grid = Array.new(6) { Array.new(7) { "-" } }
      board.reset
      expect(board.grid).to match(new_grid)
    end
  end
end

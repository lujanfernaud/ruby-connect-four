describe Game do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { described_class.new(players) }
  let(:printer) { game.printer }

  describe "attributes" do
    it "has a board" do
      expect(game.board).to be_a(Board)
    end

    it "has a players array" do
      expect(players).to match([player1, player2])
    end

    it "each player is a Player object" do
      players.all? { |player| expect(player).to be_a(Player) }
    end
  end

  describe "#start_game" do
    it "gives turns to players" do
      allow(game).to receive(:players_turns)
      game.start_game
      expect(game).to have_received(:players_turns)
    end
  end

  describe "#retry_turn" do
    let(:column) { "1" }

    before do
      allow(game).to receive(:puts)
        .with("#{player1.name}, introduce a column:")
      allow(STDIN).to receive(:gets).and_return(column)
    end

    it "asks player to introduce position again without printing board" do
      game.retry_turn(player1)
      expect(game).to have_received(:puts)
        .with("#{player1.name}, introduce a column:")
    end
  end

  describe "#try_again" do
    before do
      allow(game).to receive(:loop).and_yield
    end

    it "restarts game if 'y'" do
      allow(STDIN).to receive(:gets).and_return("y")
      allow(game).to receive(:restart_game)
      game.try_again
      expect(game).to have_received(:restart_game)
    end

    it "exits game if 'n'" do
      allow(STDIN).to receive(:gets).and_return("n")
      allow(game).to receive(:exit_game)
      game.try_again
      expect(game).to have_received(:exit_game)
    end

    it "asks to type 'y' or 'n'" do
      allow(STDIN).to receive(:gets).and_return("maybe")
      allow(printer).to receive(:print_board)
      allow(game).to receive(:puts).with("Please type 'y' or 'n'.")
      game.try_again
      expect(game).to have_received(:puts).with("Please type 'y' or 'n'.")
    end
  end
end

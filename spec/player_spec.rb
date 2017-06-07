describe Player do
  let(:player1) { described_class.new(name: "Sandi", mark: "X") }
  let(:player2) { described_class.new(name: "Player 2", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { Game.new(players) }
  let(:board)   { game.board }

  describe "attributes" do
    it "has a name" do
      expect(player1.name).to eql("Sandi")
    end

    it "allows reading and writing for :name" do
      player2.name = "Matz"
      expect(player2.name).to eql("Matz")
    end

    it "has a mark" do
      expect(player1.mark).to eql("X")
    end
  end
end

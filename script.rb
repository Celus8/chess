# frozen_string_literal: true

# Commit often
# TDD as much as I can
# Check out kinght's travails project

# Steps:
# 1. Create board with unicode characters
# 2. Make base movements for each piece
# 3. Make 2 player turn-based behaviour
# 4. Implement win or draw conditions
# 5. Implement special features (pawn reaching end, enroc)
# 6. Implement saving and loading of games
# 7. Implement AI that makes random moves

# 1. Create board with unicode characters
# Board should be an 8x8 matrix: 8 arrays, named row1, row2, row3, ..., row8, each one containig ai, bi, ci, ..., hi, where i is the row number. The first array on the board matrix is row8, and the last one row1

class Game
  def initialize
    @board = []
    8.times do |j|
      i = j + 1
      @board[7 - j] = %W[a#{i}, b#{i}, c#{i}, d#{i}, e#{i}, f#{i}, g#{i}, h#{i}]
    end
  end

  def print_board
    @board.each do |row|
      print "#{row.join(' ')}\n"
    end
  end
end

game = Game.new
game.print_board

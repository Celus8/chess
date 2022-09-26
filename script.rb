# Commit often
# TDD as much as I can

# Gameplay loop: The board is shown. The first player is whites. Which player needs to play is shown by a message. A player then inputs letter to show in what square the piece he is going to move is. The piece is highlighted in red. Then the player will select a row, and then a column. If the move is illegal, a warning sign will appear and clicking enter will do nothing. If it is legal, clicking enter will move the piece.
# Every piece is an object, which has an array of legal moves. When the player moves, unless the move he choses is in that array, a warning will appear.

# Steps:
# 1. Create board with unicode characters **
# 2. Make base movements for each piece **
# 3. Make player movement mechanic for one player
# 4. Make possibility to quit game
# 5. Make 2 player turn-based behaviour
# 6. Implement special features (pawn reaching end, enroc)
# 7. Implement win or draw conditions
# 8. Implement saving and loading of games
# 9. Implement AI that makes random moves

# 1. Create board with unicode characters

# frozen_string_literal: true

require './pieces'

WP = '♙'
WK = '♔'
WQ = '♕'
WR = '♖'
WB = '♗'
WN = '♘'
BP = '♟'
BK = '♚'
BQ = '♛'
BR = '♜'
BB = '♝'
BN = '♞'
SQUARE = '·'
SELECTED_SQUARE = 'x'
LETTERS = %w[a b c d e f g h]

class Game
  def initialize
    @number_board = []
    @board_to_print = Array.new(9) { Array.new(9, SQUARE) }
    populate_boards
    @white_pieces = []
    @black_pieces = []
  end

  def populate_boards
    8.times do |i|
      8.times do |j|
        @number_board << [i, j]
      end
    end
    # @board_to_print.each_with_index do |arr, i|
    #   arr[0] = letters[i]
    # end
    # @board_to_print[8] = [' '] + %w[1 2 3 4 5 6 7 8]

    # Provisional printed board, for easier coding, the final one is above
    @board_to_print.each_with_index do |arr, i|
      arr[0] = 7 - i

    end
    @board_to_print[8] = [' '] + %w[0 1 2 3 4 5 6 7]
  end

  def create_pieces
    create_white_pieces
    create_black_pieces

  end

  def create_white_pieces
    wp1 = Pawn.new([0, 1])
    wp2 = Pawn.new([1, 1])
    wp3 = Pawn.new([2, 1])
    wp4 = Pawn.new([3, 1])
    wp5 = Pawn.new([4, 1])
    wp6 = Pawn.new([5, 1])
    wp7 = Pawn.new([6, 1])
    wp8 = Pawn.new([7, 1])
    wk = King.new([4, 0])
    wq = Queen.new([3, 0])
    wr1 = Rook.new([0, 0])
    wr2 = Rook.new([7, 0])
    wb1 = Bishop.new([2, 0])
    wb2 = Bishop.new([5, 0])
    wn1 = Knight.new([1, 0])
    wn2 = Knight.new([6, 0])
  end

  def create_black_pieces
    bp1 = Pawn.new([0, 6], -1)
    bp2 = Pawn.new([1, 6], -1)
    bp3 = Pawn.new([2, 6], -1)
    bp4 = Pawn.new([3, 6], -1)
    bp5 = Pawn.new([4, 6], -1)
    bp6 = Pawn.new([5, 6], -1)
    bp7 = Pawn.new([6, 6], -1)
    bp8 = Pawn.new([7, 6], -1)
    bk = King.new([4, 7], -1)
    bq = Queen.new([3, 7], -1)
    br1 = Rook.new([0, 7], -1)
    br2 = Rook.new([7, 7], -1)
    bb1 = Bishop.new([2, 7], -1)
    bb2 = Bishop.new([5, 7], -1)
    bn1 = Knight.new([1, 7], -1)
    bn2 = Knight.new([6, 7], -1)
  end

  def print_board
    @board_to_print.each do |row|
      print "#{row.join(' ')}\n"
    end
  end
end

game = Game.new
game.print_board

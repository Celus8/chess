# Commit often
# TDD as much as I can

# Gameplay loop: The board is shown. The first player is whites. Which player needs to play is shown by a message. A player then inputs letter to show in what square the piece he is going to move is. The piece is highlighted in red. Then the player will select a row, and then a column. If the move is illegal, a warning sign will appear and clicking enter will do nothing. If it is legal, clicking enter will move the piece.
# Every piece is an object, which has an array of legal moves. When the player moves, unless the move he choses is in that array, a warning will appear.

# Steps:

# 1.
# Make movements to other pieces of your own team illegal.
# Make traspassing of pieces illegal except for the rook.
# Make movements to other player's pieces legal unless it's king. Assign their pos to 'dead' (or remove the instance variable), and remove them from available pieces.
# At the beginning of the game and each time a move is made, for each pair of pieces of the same team, remove one's position and every other position from then on (according to each piece) from the other's moves. If it's the knight, remove only positions. For enemy pieces, only remove every other position from then on. For the knight, do nothing. For the pawn, remove also positions, and add diagonal moves if there are enemy pieces. For all of this, exclude the king being killed (remove his pos).

# 2.
# Make pawn promotion. If pawn position is in the last row, pawn is dead and a message displays what to replace it with. The player writes what to replace it with and a new piece is created with the same pos.
# Make castling. If the king hasn't moved yet and isn't in check (and will not be in check during the passage) it can castle, and the rook moves at the same time.
# Make 2 player turn-based behaviour, displaying a message each time. Make a @current_player variable that takes the values 'black' or 'white'. Add conditional to play method.
# Winning: Remove from king all movements that are in one of the other team's allowed moves. If his pos is one of the other team's allowed moves, a message is displayed and only the king can be moved. If his pos is one of the other team's allowed moves and he has no movements, the other team wins. The game ends and a message is displayed to show who won.
# Implement saving and loading of games
# Implement AI that makes random moves

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
    @all_moves = []
    @board_to_print = Array.new(9) { Array.new(9, SQUARE) }
    populate_boards
    @white_pieces = []
    @black_pieces = []
    @selected_piece = nil
    @quit = false
    create_pieces
  end

  def play
    update_board
    print_board
    make_play until @quit
  end

  def make_play
    puts 'Select a piece to move'
    make_selection
    return if @quit

    puts 'Select a place to move it'
    make_move
    return if @quit

    print_board
  end

  def make_selection_white
    selection = gets.chomp
    if check_quit(selection)
      @quit = true
      return
    end
    return if select_white_piece(input_to_move(selection))

    puts 'Select a valid position!'
    make_selection
  end

  def make_selection_black
    selection = gets.chomp
    if check_quit(selection)
      @quit = true
      return
    end
    return if select_black_piece(input_to_move(selection))

    puts 'Select a valid position!'
    make_selection
  end

  def select_white_piece(move)
    @white_pieces.each do |piece|
      if move == piece.pos
        @selected_piece = piece
        return true
      end
    end
    false
  end

  def select_black_piece(move)
    @black_pieces.each do |piece|
      if move == piece.pos
        @selected_piece = piece
        return true
      end
    end
    false
  end

  def make_move
    move = gets.chomp
    if check_quit(move)
      @quit = true
      return
    end
    return if move_piece(input_to_move(move))

    puts 'Select a valid move!'
    make_move
  end

  def input_to_move(move)
    move.split('').map(&:to_i)
  end

  def move_piece(move)
    if @selected_piece.moves.include?(move)
      @board_to_print[7 - @selected_piece.pos[1]][@selected_piece.pos[0] + 1] = SQUARE
      @selected_piece.pos = move
      @selected_piece.create_moves
      update_board
      return true
    end
    false
  end

  def check_quit(input)
    return true if input == 'quit' || input == 'exit'
    false
  end

  def populate_boards
    8.times do |i|
      8.times do |j|
        @all_moves << [i, j]
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

  def update_board
    @all_moves.each do |square|
      @white_pieces.each do |piece|
        if piece.pos == square
          @board_to_print[7 - square[1]][square[0] + 1] = piece.icon
        end
      end
      @black_pieces.each do |piece|
        if piece.pos == square
          @board_to_print[7 - square[1]][square[0] + 1] = piece.icon
        end
      end
    end
  end

  def create_pieces
    create_white_pieces
    create_black_pieces
  end

  def create_white_pieces
    8.times do |i|
      @white_pieces.push(Pawn.new([i, 1]))
    end
    @white_pieces.push(King.new([4, 0]))
    @white_pieces.push(Queen.new([3, 0]))
    @white_pieces.push(Rook.new([0, 0]))
    @white_pieces.push(Rook.new([7, 0]))
    @white_pieces.push(Bishop.new([2, 0]))
    @white_pieces.push(Bishop.new([5, 0]))
    @white_pieces.push(Knight.new([1, 0]))
    @white_pieces.push(Knight.new([6, 0]))
  end

  def create_black_pieces
    8.times do |i|
      @black_pieces.push(Pawn.new([i, 6], -1))
    end
    @black_pieces.push(King.new([4, 7], -1)) 
    @black_pieces.push(Queen.new([3, 7], -1))
    @black_pieces.push(Rook.new([0, 7], -1))
    @black_pieces.push(Rook.new([7, 7], -1))
    @black_pieces.push(Bishop.new([2, 7], -1))
    @black_pieces.push(Bishop.new([5, 7], -1))
    @black_pieces.push(Knight.new([1, 7], -1))
    @black_pieces.push(Knight.new([6, 7], -1))
  end

  def print_board
    @board_to_print.each do |row|
      print "#{row.join(' ')}\n"
    end
  end
end

game = Game.new
game.play

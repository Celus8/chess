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

  # Fer que es dibuixin les peces a la terminal. El proper pas és detectar input del jugador, canviar les peces corresponents de pos, tenint en compte els allowed moves, fer update board i tornar a printear

  def make_play
    puts 'Select a piece to move'
    make_selection
    return if @quit

    puts 'Select a place to move it'
    make_move
    return if @quit

    print_board
  end

  def make_selection
    selection = gets.chomp
    if check_quit(selection)
      @quit = true
      return
    end
    return if select_white_piece(input_to_move(selection))

    puts 'Select a valid position!'
    make_selection
  end

  def make_move
    move = gets.chomp
    if check_quit(move)
      @quit = true
      return
    end
    return if move_white_piece(input_to_move(move))

    puts 'Select a valid move!'
    make_move
  end

  def input_to_move(move)
    move.split('').map(&:to_i)
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

  def move_white_piece(move)
    if @selected_piece.moves.include?(move)
      @board_to_print[7 - @selected_piece.pos[1]][@selected_piece.pos[0] + 1] = SQUARE
      @selected_piece.pos = move
      @selected_piece.create_moves
      update_board
      return true
    end
    false
  end

  def select_black_piece; end

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
